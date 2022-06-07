/* 
    Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com
 
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
    For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
    */

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
        countryISO = try values.decodeIfPresent(CountryCode.self, forKey: .sys)?.code
        cityName = try values.decodeIfPresent(String.self, forKey: .cityName)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
    }
    
    func encode(to encoder: Encoder) throws {
    }
}
