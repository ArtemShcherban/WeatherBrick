import Foundation

struct ResultOfRequest: Codable {
    let coordinates: Coordinates?
    let conditionMain: String?
    let conditionDetails: String?
    let temperature: Double?
    let countryISO: String?
    let cityName: String?
    let wind: Wind?
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case basicParameters = "main"
        case cityName = "name"
        case weather
        case sys
        case wind
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coordinates = try values.decodeIfPresent(Coordinates.self, forKey: .coordinates)
        conditionMain = try values.decodeIfPresent([Weather].self, forKey: .weather)?.first?.main
        conditionDetails = try values.decodeIfPresent([Weather].self, forKey: .weather)?.first?.description
        temperature = try values.decodeIfPresent(Temperature.self, forKey: .basicParameters)?.сelsius
        countryISO = try values.decodeIfPresent(CountryCode.self, forKey: .sys)?.isoCode
        cityName = try values.decodeIfPresent(String.self, forKey: .cityName)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
    }
    
    func encode(to encoder: Encoder) throws {
    }
}
