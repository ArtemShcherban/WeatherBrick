//
//  ResultViewController.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 27.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, SearchLocationViewControllerDelegate {
    static let reuseIdentifier = String(describing: ResultViewController.self)
    
    private lazy var weatherMainViewModel: WeatherMainView = {
    let view = WeatherMainView()
    return view
    }()
    
    override func loadView() {
        self.view = weatherMainViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherMainViewModel.createMainView()
    }
    
    func updateWeather(with myWeather: MyWeather) {
        weatherMainViewModel.updateWeather(with: myWeather)
    }
}
