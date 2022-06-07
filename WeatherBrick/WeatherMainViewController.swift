//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherMainViewController: UIViewController, SearchLocationViewControllerDelegate {
    static let reuseIdentifier = String(describing: WeatherMainViewController.self)
    static let shared = WeatherMainViewController()
    
    var mainQueue: Dispatching?
    
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
        mainQueue = AsyncQueue.main
        weatherMainView.createMainView()
        getMyWeather()

        weatherMainModel.getCountries()
    }
    
    func getMyWeather() {
        weatherMainModel.prepareLinkFor(location: AppConstants.ljubljana) { link in
            self.weatherMainModel.createMyWeather(with: link) { myWeatherOrError in
                switch myWeatherOrError {
                case .failure(let error):
                    print(error.rawValue)
                case .success(let myWeather):
                    self.mainQueue?.dispatch {
                        self.weatherMainView.updateWeather(with: myWeather)
                    }
                }
            }
        }
    }
    
    func updateWeather(with myWeather: MyWeather) {
        weatherMainView.updateWeather(with: myWeather)
    }
 
    func updateIcon(locator: Bool) {
        weatherMainView.setIcon(for: locator)
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
        viewController.delgate = self
        navigationController?.pushViewController(viewController, animated: true)
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
