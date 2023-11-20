import Foundation

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
