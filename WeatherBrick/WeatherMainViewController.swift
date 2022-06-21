//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit
import Network
import DeviceKit
import CoreLocation

final class WeatherMainViewController: UIViewController, SearchLocationViewControllerDelegate {
    static let reuseIdentifier = String(describing: WeatherMainViewController.self)
    static let shared = WeatherMainViewController()
    
    var mainQueue: Dispatching?
    var monitor: NWPathMonitor?
    var networkStatus = NWPath.Status.satisfied {
        didSet {
            сhangeNetworkStatusFrom(oldValue)
        }
    }
    
    private lazy var userDefaultsManager = UserDefaultsManager.manager
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
        weatherMainView.createMainView()
        getlocationFromUserDefaults()
        createNotificationObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        monitor = NWPathMonitor()
        monitorNetwork()
    }

    private func createNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlingOf(notification:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlingOf(notification:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
    
    @objc private func handlingOf(notification: NSNotification) {
        if notification.name == UIApplication.willEnterForegroundNotification {
            monitor = NWPathMonitor()
            monitorNetwork()
        } else {
            monitor?.cancel()
        }
    }
    
    private func getlocationFromUserDefaults() {
        mainQueue?.dispatch {
            self.weatherMainView.circleAnimation.start()
        }
        guard let location = self.userDefaultsManager.getLocation() else { return }
        self.getMyWeatherFor(location)
    }
    
    private func getMyWeatherFor(_ location: CLLocation) {
        networkServiceModel.prepareLinkFor(location: location) { link in
            self.weatherMainModel.createMyWeather(with: link) { myWeatherOrError in
                switch myWeatherOrError {
                case .failure(let error):
                    self.mainQueue?.dispatch {
                        self.weatherMainView.circleAnimation.stop()
                        self.weatherMainView.errorMessageTextLabel.retrieveError = error.rawValue
                    }
                case .success(let myWeather):
                    self.mainQueue?.dispatch {
                        self.weatherMainView.circleAnimation.stop()
                        self.weatherMainView.errorMessageTextLabel.isActive = false
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
    
    private func сhangeNetworkStatusFrom(_ oldValue: NWPath.Status) {
        if networkStatus == NWPath.Status.satisfied && oldValue != NWPath.Status.satisfied {
            sleep(UInt32(3.0))
            getlocationFromUserDefaults()
            mainQueue?.dispatch {
                self.weatherMainView.stoneImageView.image = UIImage(named: AppConstants.StoneImage.normal)
                self.weatherMainView.errorMessageTextLabel.isActive = false
                self.weatherMainView.locationButton.isActive = true
            }
        } else if networkStatus == NWPath.Status.unsatisfied {
            self.mainQueue?.dispatch {
                self.weatherMainView.locationButton.isActive = false
                self.weatherMainView.errorMessageTextLabel.retrieveError = NetworkServiceError.errorCallingGET.rawValue
                self.weatherMainView.stoneImageView.image = UIImage(named: AppConstants.StoneImage.noStone)
            }
        }
    }
    
    private func monitorNetwork() {
        monitor?.pathUpdateHandler = { path in
            self.networkStatus = path.status
        }
        let queue = DispatchQueue(label: AppConstants.monitor)
        monitor?.start(queue: queue)
    }
}

extension WeatherMainViewController: WeatherMainViewDelegate {
    func didSwipe() {
        weatherMainView.errorMessageTextLabel.isActive = false
        weatherMainView.stoneImageView.swipeAnimation()
        getlocationFromUserDefaults()
    }
    
    func locationButtonPressed() {
        weatherMainView.errorMessageTextLabel.isActive = false
        let storyboard = UIStoryboard(name: AppConstants.main, bundle: nil)
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
