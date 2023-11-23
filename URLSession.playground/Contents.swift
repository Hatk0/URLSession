import Foundation

// Данные для работы с Marvel API и вызов метода генерации hash
let publicKey = "6ee356d5267181fe73bba904f4c82975"
let privateKey = "90bedb28b32e2fdc7be275e7ae2a5d496f671908"
let hash = ("1" + privateKey + publicKey).md5()

// URLComponents для Marvel API
var urlComponents = URLComponents()
urlComponents.scheme = "https"
urlComponents.host = "gateway.marvel.com"
urlComponents.path = "/v1/public/characters"
urlComponents.queryItems = [
    URLQueryItem(name: "ts", value: "1"),
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
