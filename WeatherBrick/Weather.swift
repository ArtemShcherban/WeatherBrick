import Foundation

struct Weather: Codable {
    let main: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        main = try values.decodeIfPresent(String.self, forKey: .main)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
}
