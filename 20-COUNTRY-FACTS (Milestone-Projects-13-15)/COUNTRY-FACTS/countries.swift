import Foundation

// MARK: - Country
struct countries: Codable {
    let currencies: [Currency]
    let languages: [Language]
    let flag: String
    let name, alpha2Code, capital: String
    let region: Region
    let population: Int
    let demonym: String
    let area: Double?
    let timezones: [String]
    let nativeName: String
}

// MARK: - Currency
struct Currency: Codable {
    let code, name, symbol: String?
}

// MARK: - Language
struct Language: Codable {
    let iso6391: String?
    let iso6392, name, nativeName: String

    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso639_1"
        case iso6392 = "iso639_2"
        case name, nativeName
    }
}

enum Region: String, Codable {
    case africa = "Africa"
    case americas = "Americas"
    case asia = "Asia"
    case empty = ""
    case europe = "Europe"
    case oceania = "Oceania"
    case polar = "Polar"
}

typealias Countries = [countries]
