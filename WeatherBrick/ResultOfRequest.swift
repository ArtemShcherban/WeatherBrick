import Foundation

struct ResultOfRequest: Codable {
    let coordinates: LocationCoordinate?
    let conditionMain: String?
    let conditionDetails: String?
    let temperature: Double?
    let countryISO: String?
    let cityName: String?
    let windParameters: WindParameters?
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case basicParameters = "main"
        case cityName = "name"
        case windParameters = "wind"
        case weather
        case sys
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coordinates = try values.decodeIfPresent(LocationCoordinate.self, forKey: .coordinates)
        conditionMain = try values.decodeIfPresent([Weather].self, forKey: .weather)?.first?.main
        conditionDetails = try values.decodeIfPresent([Weather].self, forKey: .weather)?.first?.description
        temperature = try values.decodeIfPresent(Temperature.self, forKey: .basicParameters)?.сelsius
        countryISO = try values.decodeIfPresent(CountryCode.self, forKey: .sys)?.isoCode
        cityName = try values.decodeIfPresent(String.self, forKey: .cityName)
        windParameters = try values.decodeIfPresent(WindParameters.self, forKey: .windParameters)
    }
    
    func encode(to encoder: Encoder) throws {
    }
}
