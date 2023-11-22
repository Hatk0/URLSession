import Foundation
import CryptoKit

func MD5(string: String) -> Data {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
        messageData.withUnsafeBytes { messageBytes -> UInt8 in
            if let messageBytesBaseAddress = messageBytes.baseAddress,
               let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(messageData.count)
                CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
            }
            return 0
        }
    }
    return digestData
}

func generateHash(timestamp: String, privateKey: String, publicKey: String) -> String {
    let combinedString = timestamp + privateKey + publicKey
    let hashData = MD5(string: combinedString)
    let hash = hashData.map { String(format: "%02hhx", $0) }.joined()
    return hash
}

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { 
        print("Ссылка сформированна некорректно")
        return
    }
    URLSession.shared.dataTask(with: url) { data, response, error in
        if error != nil {
            print("Ошибка: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("Код ответа от сервера: \(response.statusCode)")
            } else {
                print("Невозможно получить ответ от сервера")
            }
            
            if let data = data, let dataAsString = String(data: data, encoding: .utf8) {
                print("Данные, пришедшие от сервера: \(dataAsString)")
            } else {
                print("Данные не получены или не могут быть преобразованы в нужный формат")
            }
        }
    }.resume()
}

getData(urlRequest: "https://meowfacts.herokuapp.com/?lang=rus")

// Проверка на работу некорректности ссылки
//getData(urlRequest: "")
