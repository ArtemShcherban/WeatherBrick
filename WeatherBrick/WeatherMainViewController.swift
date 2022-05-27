//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit

class WeatherMainViewController: UIViewController, SearchLocationViewControllerDelegate {
    static let reuseIdentifier = String(describing: WeatherMainViewController.self)
    static let shared = WeatherMainViewController()
    
    var networkServiceURLmodel = NetworkServiceURL.shared
    
    var myWeatherVar: MyWeather?
    
    private lazy var weatherMainModel: WeatherMainModel = {
        WeatherMainModel.shared
    }()
    
    private lazy var weatherMainView: WeatherMainView = {
        let view = WeatherMainView()
        view.delegate = self
        view.popUpWindow.delegate = self
        return view
    }()
    
    override func loadView() {
        self.view = weatherMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherMainView.createMainView()
        weatherMainModel.getCities()
        weatherMainModel.getMyWeather(in: AppConstants.ljubljana) { myWeather in
            DispatchQueue.main.async {
                self.weatherMainView.updateWeather(with: myWeather)
            }
        }
        
    weatherMainModel.getCountries {
        print("finish")
    }
}
    
    func updateWeather(with myWeather: MyWeather) {
        self.weatherMainView.updateWeather(with: myWeather)
    }
}

extension WeatherMainViewController: WeatherMainViewDelegate {
    func testButtonPressed() {
    }
    
    func locationButtonPressed() {
        print("Button pressed")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController =
            storyboard.instantiateViewController(withIdentifier:
            SearchLocationViewController.reuseIdentifier) as? SearchLocationViewController else { return }
        //        viewController.modalPresentationStyle = .fullScreen
        viewController.delgate = self
        //                    self.present(viewController, animated: true, completion: nil)
            navigationController?.pushViewController(viewController, animated: true)
        
        //                weatherMainModel.getMyWeather(in: AppConstants.cities[Int.random(in: 0...3)]) { myWeather in
        //                    DispatchQueue.main.async {
        //                        self.weatherMainView.updateWeather(with: myWeather)
        //                    }
        //                }
    }
}

extension WeatherMainViewController: PopUpWindowDelegate {
    func animateFirst() {
        print("Tap")
        weatherMainView.animateGradient()
    }
    
    func animateSecond() {
        print("Hide")
        weatherMainView.animatePopUpWindowOut()
    }
}
