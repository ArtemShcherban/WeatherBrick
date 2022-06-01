//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit

class WeatherMainViewController: UIViewController, SearchLocationViewControllerDelegate {
    static let reuseIdentifier = String(describing: WeatherMainViewController.self)
    static let shared = WeatherMainViewController()
    var networkServiceURLmodel = NetworkServiceURL.shared
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
        tryGetMyWeather()
        
        weatherMainModel.getCities()
        weatherMainModel.getCountries()
    }
    
    func tryGetMyWeather() {
        weatherMainModel.getMyWeather(in: AppConstants.ljubljana) { myWeatherOrErrors in
            switch myWeatherOrErrors {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let myWeather):
                self.mainQueue?.dispatch {
                self.weatherMainView.updateWeather(with: myWeather)
                }
            }
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
