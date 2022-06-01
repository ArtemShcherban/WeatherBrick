//
//  SearchLocationViewController.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 24.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class SearchLocationViewController: UIViewController {
    static let reuseIdentifier = String(describing: SearchLocationViewController.self)
    static let shared = SearchLocationViewController()
    weak var delgate: SearchLocationViewControllerDelegate?
    
    var mainQueue: Dispatching?
    
//    var tempArrayFinal: [City] = []
//    var filteredLocations: [City] = []
//    var cities: [City] = []
    
    private lazy var weatherMainModel = WeatherMainModel.shared
    
    private lazy var searchLocationViewModel: SearchLocationView = {
        let view = SearchLocationView()
        view.delegate = self
        return view
    }()
    
    override func loadView() {
        self.view = searchLocationViewModel
    }
    
    private var isSearchBarEmpty: Bool {
        searchLocationViewModel.searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainQueue = AsyncQueue.main
        searchLocationViewModel.createSearchLocationMainView()
        navigationItem.searchController = searchLocationViewModel.searchController
    }
}

extension SearchLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension SearchLocationViewController: SearchLocationViewModelDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBar.text?.replacingOccurrences(of: " ", with: "+") else { return }
        
        weatherMainModel.getMyWeather(in: location) { myWeatherOrError in
            switch myWeatherOrError {
            case .failure(let error):
                self.mainQueue?.dispatch {
                    self.searchLocationViewModel.addErrorTextLabel(with: error.rawValue)
                }
            case .success(let myWeather):
                self.mainQueue?.dispatch {
                    self.delgate?.updateWeather(with: myWeather)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true &&
            searchLocationViewModel.errorTextLabel.superview === self.view {
            searchLocationViewModel.errorTextLabel.removeFromSuperview()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchLocationViewModel.errorTextLabel.superview === self.view {
            searchLocationViewModel.errorTextLabel.removeFromSuperview()
        }
    }
}

protocol SearchLocationViewControllerDelegate: AnyObject {
    func updateWeather(with myWeather: MyWeather)
}
