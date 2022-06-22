//
//  CountryServiceModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 21.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

class AdditionalServiceModels {
    func getCountries(completion: @escaping(([Any]) -> Void) ) {
        guard let url = Bundle.main.url(forResource: "CountriesWithFlags", withExtension: "json"),
            let data = try? Data(contentsOf: url),
                let json = try? JSONSerialization.jsonObject(
                with: data,
                options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [Any] else { return }
        completion(json)
    }
}
