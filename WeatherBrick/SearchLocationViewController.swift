//
//  SearchLocationViewController.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 24.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchLocationViewControllerDelegate: AnyObject {
    func updateWeather(with myWeather: WeatherInfo)
    func updateIcon(isGeo geoLocation: Bool)
}

final class SearchLocationViewController: UIViewController {
    static let reuseIdentifier = String(describing: SearchLocationViewController.self)
    static let shared = SearchLocationViewController()
    weak var delgate: SearchLocationViewControllerDelegate?
    
    var mainQueue: Dispatching?
    
    private lazy var locationManager = CLLocationManager()
    
    private var userDefaultsManager = UserDefaultsManager.manager
    private lazy var weatherNetworkServiceModel = URLModel.shared
    private lazy var searchLocationModel = SearchLocationModel.shared
    private lazy var weatherMainModel = WeatherViewModel.shared
    private lazy var weatherMainView = WeatherMainView.shared
    
    private lazy var searchLocationView: SearchLocationView = {
        let view = SearchLocationView()
        view.delegate = self
        view.searchBarDelegate = self
        return view
    }()
    
    override func loadView() {
        self.view = searchLocationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainQueue = AsyncQueue.main
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        searchLocationView.createSearchLocationMainView()
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        navigationItem.searchController = searchLocationView.searchController
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = searchLocationView.backButton
    }
    
    private func getMyWeatherFor<T: Locatable>(_ location: T, compleation: @escaping(WeatherInfo) -> Void) {
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
                        self.searchLocationView.circleAnimation.stop()
                        compleation(myWeather)
                    }
                }
            }
        }
    }
    
    private func received(error: NetworkServiceError) {
        self.mainQueue?.dispatch {
            self.searchLocationView.circleAnimation.stop()
            self.searchLocationView.messageTextLabel.retrieveError = error.localizedDescription
            self.searchLocationView.messageTextLabel.isActive = true
        }
    }
    
    private func returnNewLocationWith(_ myWeather: WeatherInfo, geoLocation: Bool) {
        delgate?.updateWeather(with: myWeather)
        delgate?.updateIcon(isGeo: geoLocation)
        navigationController?.popViewController(animated: true)
    }
}

extension SearchLocationViewController: SearchLocationViewDelegate {
    func backButtonPressed() {
        if let weather = userDefaultsManager.getWeatherInfo() {
            delgate?.updateWeather(with: weather)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func userLocattionButtonPressed() {
        searchLocationView.userLocationButton.isSelected = true
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            searchLocationView.userLocationButton.isSelected = false
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension SearchLocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse && searchLocationView.userLocationButton.isSelected else { return }
            userLocattionButtonPressed()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        searchLocationView.startCircleAnimation()
        getMyWeatherFor(location) { myWeather in
            self.returnNewLocationWith(myWeather, geoLocation: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension SearchLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBartext = searchBar.text else { return }
        searchLocationView.startCircleAnimation()
        if searchLocationModel.hasValidCoordinates(searchBartext) {
            guard let location = searchLocationModel.location(from: searchBartext) else {
                searchLocationView.messageTextLabel.retrieveError =
                NetworkServiceError.httpRequestFailed.rawValue
                searchLocationView.messageTextLabel.isActive = true
                return
            }
            getMyWeatherFor(location) { myWeather in
                self.returnNewLocationWith(myWeather, geoLocation: false)
            }
        } else {
            guard let location = searchBar.text?.replacingOccurrences(of: " ", with: "+") else { return }
            getMyWeatherFor(location) { myWeather in
                self.returnNewLocationWith(myWeather, geoLocation: false)
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchLocationView.messageTextLabel.isActive = false
        searchLocationView.containerView.fadeTransition(0.5)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true {
            searchLocationView.messageTextLabel.isActive = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchLocationView.messageTextLabel.isActive = false
        searchLocationView.containerView.fadeTransition(0.5)
    }
}

extension CLLocation: Locatable {}
extension String: Locatable {}
