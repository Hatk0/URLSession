import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

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
        print("Ссылка сформирована некорректно")
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

// Данные для работы с Marvel API и вызов метода генерации hash
let timestamp = String(Date().timeIntervalSince1970)
let publicKey = "6ee356d5267181fe73bba904f4c82975"
let privateKey = "90bedb28b32e2fdc7be275e7ae2a5d496f671908"
let hash = generateHash(timestamp: timestamp, privateKey: privateKey, publicKey: publicKey)

// Вывод информации в консоль про ts и hash
print("Timestamp: \(timestamp)")
print("Hash: \(hash)")

// URLComponents для Marvel API
var urlComponents = URLComponents()
urlComponents.scheme = "https"
urlComponents.host = "gateway.marvel.com"
urlComponents.path = "/v1/public/characters/231311/series"
urlComponents.queryItems = [
    URLQueryItem(name: "ts", value: timestamp),
    URLQueryItem(name: "apikey", value: publicKey),
    URLQueryItem(name: "hash", value: hash)
]

if let marvelURL = urlComponents.url {
    getData(urlRequest: marvelURL.absoluteString)
} else {
    print("Невозможно создать адрес")
}

// Проверка на работу Meow API
getData(urlRequest: "https://meowfacts.herokuapp.com/?lang=rus")

// Проверка на работу некорректности ссылки
//getData(urlRequest: "")
