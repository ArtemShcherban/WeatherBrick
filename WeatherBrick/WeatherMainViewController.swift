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
    
    var monitor = NWPathMonitor()
    
    var networkStatus = NWPath.Status.unsatisfied {
        didSet {
            сhangeNetworkStatusFrom(oldValue)
        }
    }
    
//    lazy var statusOfNetWork = "NOT OK" {
//        didSet {
//            if statusOfNetWork == "OK" && oldValue != "OK" {
//                print("SEND REQUEST TO SERVER")
//            } else if statusOfNetWork == "NOT OK" {
//                print("NO STONE")
//            }
//        }
//    }
    
    var mainQueue: Dispatching?
    
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
        monitorNetwork()
        
        guard let location = self.userDefaultsManager.getLocation() else { return }
        self.getMyWeatherFor(location)
        weatherMainView.createMainView()
//        createNotificationObserver()
    }
    
    private func createNotificationObserver() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(applicationOnScreen(notification:)),
//            name: UIApplication.willEnterForegroundNotification,
//            object: nil)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(applicationOnScreen(notification:)),
//            name: UIApplication.willResignActiveNotification,
//            object: nil)
    }
    
    @objc private func applicationOnScreen(notification: NSNotification) {
        if notification.name == UIApplication.willEnterForegroundNotification {
            monitorNetwork()
        } else {
            monitor.cancel()
        }
    }
    
    private func getMyWeatherFor(_ location: CLLocation) {
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
    
    func сhangeNetworkStatusFrom(_ oldValue: NWPath.Status) {
        if networkStatus == NWPath.Status.satisfied && oldValue != NWPath.Status.satisfied {
            sleep(UInt32(3))
            guard let location = self.userDefaultsManager.getLocation() else { return }
            self.getMyWeatherFor(location)
            print("SEND REQUEST TO SERVER")
        } else if networkStatus == NWPath.Status.unsatisfied && oldValue != NWPath.Status.unsatisfied {
            self.mainQueue?.dispatch {
                self.weatherMainView.stoneImageView.image = UIImage(named: AppConstants.StoneImage.noStone)
                print("NO STONE")
            }
        }
    }
    
//    private func monitorNetwork() {
//        //        self.monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                //                self.statusOfNetWork = "OK"
//                self.currentStatus = path.status
//                print("NETWORK IS OK")
//                //                guard let location = self.userDefaultsManager.getLocation() else { return }
//                //                self.getMyWeatherFor(location)
//            } else {
//                //                self.statusOfNetWork = "NOT OK"
//                self.currentStatus = path.status
//                print("CONNECTION LOST")
//                //                self.mainQueue?.dispatch {
//                //                    self.weatherMainView.stoneImageView.image = UIImage(named: AppConstants.StoneImage.noStone)
//                //                }
//            }
//        }
//        let queue = DispatchQueue(label: "Monitor")
//        monitor.start(queue: queue)
//    }
    
    private func monitorNetwork() {
        monitor.pathUpdateHandler = { path in
            self.networkStatus = path.status
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
