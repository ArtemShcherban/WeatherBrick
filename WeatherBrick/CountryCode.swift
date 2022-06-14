import Foundation

struct CountryCode: Codable {
    let isoCode: String?
    
    enum CodingKeys: String, CodingKey {
        case isoCode = "country"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isoCode = try values.decodeIfPresent(String.self, forKey: .isoCode)
    }
}
