import Foundation

struct LocationCoordinate: Codable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude) ?? Double()
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude) ?? Double()
    }
}
