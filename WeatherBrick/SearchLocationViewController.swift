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
    
    let locationManager = CLLocationManager()
    
    private lazy var weatherMainModel = WeatherMainModel.shared
    private lazy var weatherMainView = WeatherMainView.shared
    
    private lazy var searchLocationViewModel: SearchLocationView = {
        let view = SearchLocationView()
        view.delegate = self
        view.searchBarDelegate = self
        return view
    }()
    
    override func loadView() {
        self.view = searchLocationViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainQueue = AsyncQueue.main
        
        //        CLLocationManager.locationServicesEnabled()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        searchLocationViewModel.createSearchLocationMainView()
        navigationItem.searchController = searchLocationViewModel.searchController
    }
    
    func getMyWeatherFor<T>(_ location: T, compleation: @escaping(MyWeather) -> Void) {
        weatherMainModel.prepareLinkFor(location: location) { link in
            self.weatherMainModel.createMyWeather(with: link) { myWeatherOrError in
                switch myWeatherOrError {
                case .failure(let error):
                    self.mainQueue?.dispatch {
                        self.searchLocationViewModel.addErrorTextLabel(with: error.rawValue)
                    }
                case .success(let myWeather):
                    self.mainQueue?.dispatch {
                    compleation(myWeather)
                    }
                }
            }
        }
    }
}

extension SearchLocationViewController: SearchLocationViewModelDelegate {
    func userLocattionButtonPressed() {
        searchLocationViewModel.userLocationButton.isSelected = true
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            searchLocationViewModel.userLocationButton.isSelected = false
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension SearchLocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse && searchLocationViewModel.userLocationButton.isSelected {
            userLocattionButtonPressed()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getMyWeatherFor(location) { myWeather in
                self.delgate?.updateWeather(with: myWeather)
                self.delgate?.updateIcon(locator: true)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension SearchLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBar.text?.replacingOccurrences(of: " ", with: "+") else { return }
        
        getMyWeatherFor(location) { myWeather in
            self.delgate?.updateWeather(with: myWeather)
            self.delgate?.updateIcon(locator: false)
            self.navigationController?.popViewController(animated: true)
        }
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true &&
            searchLocationViewModel.errorTextLabel.superview === self.view {
            searchLocationViewModel.errorTextLabel.isActive = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchLocationViewModel.errorTextLabel.superview === self.view {
            searchLocationViewModel.errorTextLabel.isActive = false
        }
    }
}

protocol SearchLocationViewControllerDelegate: AnyObject {
    func updateWeather(with myWeather: MyWeather)
    func updateIcon(locator: Bool)
}
