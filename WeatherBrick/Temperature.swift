import Foundation

struct Temperature: Codable {
    let сelsius: Double
    
    enum CodingKeys: String, CodingKey {
        case сelsius = "temp"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        сelsius = try values.decodeIfPresent(Double.self, forKey: .сelsius) ?? Double()
    }
}
