//
//  SearchLocationViewController.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 24.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import CoreLocation

final class SearchLocationViewController: UIViewController {
    static let reuseIdentifier = String(describing: SearchLocationViewController.self)
    static let shared = SearchLocationViewController()
    weak var delgate: SearchLocationViewControllerDelegate?
    
    var mainQueue: Dispatching?
    
    private lazy var locationManager = CLLocationManager()
    
    private lazy var userDefaultsManager = UserDefaultsManager.manager
    private lazy var networkServiceModel = NetworkServiceModel.shared
    private lazy var searchLocationModel = SearchLocationModel.shared
    private lazy var weatherMainModel = WeatherMainModel.shared
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
    
    private func getMyWeatherFor<T: Locatable>(_ location: T, compleation: @escaping(MyWeather) -> Void) {
        networkServiceModel.prepareLinkFor(location: location) { link in
            self.weatherMainModel.createMyWeather(with: link) { myWeatherOrError in
                switch myWeatherOrError {
                case .failure(let error):
                    self.mainQueue?.dispatch {
                        self.searchLocationView.messageTextLabel.retrieveError = error.rawValue
                        self.searchLocationView.messageTextLabel.isActive = true
                    }
                case .success(let myWeather):
                    self.mainQueue?.dispatch {
                        compleation(myWeather)
                    }
                }
            }
        }
    }
    
    private func returnNewLocationWith(_ myWeather: MyWeather, geoLocation: Bool) {
        delgate?.updateWeather(with: myWeather)
        delgate?.updateIconWith(geoLocation)
        navigationController?.popViewController(animated: true)
    }
}

extension SearchLocationViewController: SearchLocationViewModelDelegate {
    func backButtonPressed() {
        guard let myWeather = userDefaultsManager.getMyWeather() else {
            navigationController?.popViewController(animated: true)
            return
        }
        delgate?.updateWeather(with: myWeather)
        navigationController?.popViewController(animated: true)
    }
    
    func userLocattionButtonPressed() {
        searchLocationView.userLocationButton.isSelected = true
        let status = locationManager.authorizationStatus
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
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse && searchLocationView.userLocationButton.isSelected {
            userLocattionButtonPressed()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            searchLocationView.messageTextLabel.startActivityIndicatorAnimation()
            getMyWeatherFor(location) { myWeather in
                self.returnNewLocationWith(myWeather, geoLocation: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension SearchLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBartext = searchBar.text {
            searchLocationView.messageTextLabel.startActivityIndicatorAnimation()
            if searchLocationModel.textLooksLikeCoordinates(searchBartext) {
                guard let location = searchLocationModel.tryCreateLocationFrom(searchBartext) else {
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

protocol SearchLocationViewControllerDelegate: AnyObject {
    func updateWeather(with myWeather: MyWeather)
    func updateIconWith(_ geoLocation: Bool)
}

protocol Locatable {}
extension CLLocation: Locatable {}
extension String: Locatable {}
