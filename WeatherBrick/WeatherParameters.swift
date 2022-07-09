import Foundation

struct WeatherParameters: Decodable {
    let coordinates: LocationCoordinate
    let conditionMain: String
    let conditionDetails: String
    let temperature: Double
    let countryISO: String
    let cityName: String
    let windParameters: WindParameters
    
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
        coordinates = try values.decode(LocationCoordinate.self, forKey: .coordinates)
        conditionMain = try values.decode([Weather].self, forKey: .weather).first?.main ?? String()
        conditionDetails = try values.decode([Weather].self, forKey: .weather).first?.description ?? String()
        temperature = try values.decode(Temperature.self, forKey: .basicParameters).сelsius
        countryISO = try values.decode(CountryCode.self, forKey: .sys).isoCode
        cityName = try values.decode(String.self, forKey: .cityName)
        windParameters = try values.decode(WindParameters.self, forKey: .windParameters)
    }
    
    init(coordinates: LocationCoordinate, conditionMain: String, conditionDetails: String, temperature: Double, countryISO: String, cityName: String, windParameters: WindParameters) {
        self.coordinates = coordinates
        self.conditionMain = conditionMain
        self.conditionDetails = conditionDetails
        self.temperature = temperature
        self.countryISO = countryISO
        self.cityName = cityName
        self.windParameters = windParameters
    }
}
