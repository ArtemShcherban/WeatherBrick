//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit
import Network
import CoreLocation

final class WeatherMainViewController: UIViewController, SearchLocationViewControllerDelegate {
    static let reuseIdentifier = String(describing: WeatherMainViewController.self)
    static let shared = WeatherMainViewController()
    
    let userDefaultsManager = UserDefaultsManager.manager
    
    let monitor = NWPathMonitor()
    
    var mainQueue: Dispatching?
    
    private lazy var networkServiceModel = NetworkServiceModel.shared
    
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
        monitorNetwork()
        weatherMainView.createMainView()
    }
    
    private func getMyWeatherFor<T>(_ location: T) {
        networkServiceModel.prepareLinkFor(location: location) { link in
            self.weatherMainModel.createMyWeather(with: link) { myWeatherOrError in
                switch myWeatherOrError {
                case .failure(let error):
                    print(error.rawValue)
                case .success(let myWeather):
                    self.mainQueue?.dispatch {
                        self.updateWeather(with: myWeather)
                    }
                }
            }
        }
    }
    
    func updateWeather(with myWeather: MyWeather) {
        userDefaultsManager.save(myWeather)
        weatherMainView.updateWeather(with: myWeather)
    }
    
    func updateIconWith(_ geoLocation: Bool) {
        weatherMainView.setIconFor(geoLocation)
    }
    
    private func monitorNetwork() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                guard let location = self.userDefaultsManager.getLocation() else { return }
                self.getMyWeatherFor(location)
            } else {
                self.mainQueue?.dispatch {
                    self.weatherMainView.stoneImageView.image = UIImage(named: AppConstants.StoneImage.noStone)
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}

extension WeatherMainViewController: WeatherMainViewDelegate {
    func didSwipe() {
        weatherMainView.stoneImageView.swipeAnimation()
        guard let location = userDefaultsManager.getLocation() else { return }
        getMyWeatherFor(location)
    }
    
    func locationButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController =
            storyboard.instantiateViewController(withIdentifier:
            SearchLocationViewController.reuseIdentifier) as? SearchLocationViewController else { return }
        viewController.delgate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension WeatherMainViewController: PopUpWindowDelegate {
    func popWindowIn() {
        weatherMainView.animatePopUpWindowIn()
    }
    
    func popWindowOut() {
        weatherMainView.animatePopUpWindowOut()
    }
}
