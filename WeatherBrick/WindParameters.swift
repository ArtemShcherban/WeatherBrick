import Foundation

struct WindParameters: Codable {
    let speed: Double
    let degrees: Int
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed) ?? 0.0
        degrees = try values.decodeIfPresent(Int.self, forKey: .degrees) ?? 0
    }
}
