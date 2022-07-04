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
    
    var mainQueue: Dispatching?
    private var monitor: NWPathMonitor?
    private var networkStatus = NWPath.Status.satisfied {
        didSet {
            сhangeNetworkStatus(from: oldValue)
        }
    }
    
    private var userDefaultsManager = UserDefaultsManager.manager
    private var weatherNetworkServiceModel = URLModel.shared
    
    private lazy var weatherMainModel: WeatherViewModel = {
        WeatherViewModel.shared
    }()
    
    private lazy var weatherMainView: WeatherMainView = {
        let view = WeatherMainView()
        view.delegate = self
        view.popUpWindow.delegate = self
        return view
    }()
    
    override func loadView() {
        mainQueue = AsyncQueue.main
        self.view = weatherMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherMainView.setupMainView()
        getDataFromNetwork()
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
    
    private func getDataFromNetwork() {
        mainQueue?.dispatch {
            self.weatherMainView.circleAnimation.start()
        }
        guard let location = self.userDefaultsManager.getLocation() else { return }
        self.getWeatherFor(location)
    }
    
    private func getWeatherFor(_ location: CLLocation) {
        let result = weatherNetworkServiceModel.prepareLinkFor(location: location)
        switch result {
        case .failure(let error):
            self.received(error: error)
        case .success(let url):
            self.weatherMainModel.createWeatherInfo(with: url) { myWeatherOrError in
                switch myWeatherOrError {
                case .failure(let error):
                    self.received(error: error)
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
    
    func received(error: NetworkServiceError) {
        mainQueue?.dispatch {
            self.weatherMainView.circleAnimation.stop()
            self.weatherMainView.errorMessageTextLabel.retrieveError = error.localizedDescription
        }
    }
    
    func updateWeather(with myWeather: WeatherInfo) {
        userDefaultsManager.save(myWeather)
        weatherMainView.updateWeather(with: myWeather)
    }
    
    func updateIcon(isGeo geoLocation: Bool) {
        weatherMainView.setIcon(isGeo: geoLocation)
    }
    
    private func сhangeNetworkStatus(from oldValue: NWPath.Status) {
        if networkStatus == NWPath.Status.satisfied && oldValue != NWPath.Status.satisfied {
            sleep(UInt32(3.0))
            getDataFromNetwork()
            mainQueue?.dispatch {
                self.weatherMainView.stoneImageView.image = UIImage(named: ImagesConstants.StoneImage.normal)
                self.weatherMainView.errorMessageTextLabel.isActive = false
                self.weatherMainView.locationButton.isActive = true
            }
        } else if networkStatus == NWPath.Status.unsatisfied {
            self.mainQueue?.dispatch {
                self.weatherMainView.locationButton.isActive = false
                self.weatherMainView.errorMessageTextLabel.retrieveError = NetworkServiceError.errorCallingGET.rawValue
                self.weatherMainView.stoneImageView.image = UIImage(named: ImagesConstants.StoneImage.noStone)
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
        getDataFromNetwork()
    }
    
    func locationButtonPressed() {
        weatherMainView.circleAnimation.stop()
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
    func popWindowPush() {
        weatherMainView.animatePopUpWindowIn()
    }
    
    func popWindowOut() {
        weatherMainView.animatePopUpWindowOut()
    }
}
