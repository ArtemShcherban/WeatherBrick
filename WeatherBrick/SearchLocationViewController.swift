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
    weak var delgate: SearchLocationViewControllerDelegate?
    
    var tempArrayFinal: [City] = []
    var filteredLocations: [City] = []
    var cities: [City] = []
    
    private lazy var weatherMainModel = WeatherMainModel.shared
    
    private lazy var searchLocationViewModel: SearchLocationViewModel = {
        let view = SearchLocationViewModel()
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

        weatherMainModel.getMyWeather(in: location) { myWeather in
            DispatchQueue.main.async {
                self.delgate?.updateWeather(with: myWeather)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count ?? 0 >= 0 {
//            let cities = self.tempArrayFinal.isEmpty ? self.weatherMainModel.cities : self.tempArrayFinal
//            print(cities.count)
//            let start = DispatchTime.now()
//            let tempArray = cities.filter { city in
//                city.name.contains(searchText)
//            }
//            self.tempArrayFinal = tempArray
//            
//            let end = DispatchTime.now()
//            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
//            let time = (Double(nanoTime) / 1_000_000) / 1000
//            print("Time in seconds is: \(time)")
//            //            print(tempArray.count)
//        }
//        print(searchBar.text ?? "")
//        //        print(tempArrayFinal)
    }
}

protocol SearchLocationViewControllerDelegate: AnyObject {
    func updateWeather(with myWeather: MyWeather)
}
