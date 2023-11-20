import Foundation

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
        if error != nil {
            print("Ошибка: \(error)")
        } else {
            if let response = response as? HTTPURLResponse {
                print("Код ответа от сервера: \(response.statusCode)")
            } else {
                print("Невозможно получить ответ от сервера")
            }
            
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            
        }
    }.resume()
}

getData(urlRequest: "https://meowfacts.herokuapp.com/?lang=rus")
