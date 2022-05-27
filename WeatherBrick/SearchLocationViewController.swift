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
    private lazy var weatherMainView = WeatherMainView.shared
    
    
    
    private lazy var searchController = UISearchController(searchResultsController: nil)

    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    
    private lazy var searchLocationViewModel: SearchLocationViewModel = {
        let view = SearchLocationViewModel()
        view.delegate = self
        view.tableViewDelegate = self
        view.tableViewDataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = searchLocationViewModel
        searchLocationViewModel.createSearchLocationMainView()
        configureSearchController()
        searchLocationViewModel.createTableView()
        cities = weatherMainModel.cities
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    func filteredCitiesForSearchText() {
    }
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = String(indexPath.row)
        cell?.backgroundColor = .gray
        return cell ?? UITableViewCell()
    }
}

extension SearchLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}

extension SearchLocationViewController: SearchLocationViewModelDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBar.text?.replacingOccurrences(of: " ", with: "") else { return }
        
        weatherMainModel.getMyWeather(in: location) { myWeather in
            DispatchQueue.main.async {
                self.weatherMainView.updateWeather(with: myWeather)
                self.delgate?.updateWeather(with: myWeather)
                print(myWeather)
                
                //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //                guard let viewController = storyboard.instantiateViewController(withIdentifier:
                //                                            WeatherMainViewController.reuseIdentifier) as? WeatherMainViewController else { return }
                //                viewController.modalPresentationStyle = .fullScreen
                //                self.present(viewController, animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count ?? 0 >= 3 {
            let cities = self.tempArrayFinal.isEmpty ? self.weatherMainModel.cities : self.tempArrayFinal
            print(cities.count)
            let start = DispatchTime.now()
            let tempArray = cities.filter { city in
                city.name.contains(searchText)
            }
            self.tempArrayFinal = tempArray
           
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time = (Double(nanoTime) / 1_000_000) / 1000
            print("Time in seconds is: \(time)")
            //            print(tempArray.count)
        }
        print(searchBar.text ?? "")
        //        print(tempArrayFinal)
    }
}

protocol SearchLocationViewControllerDelegate: AnyObject {
    func updateWeather(with myWeather: MyWeather)
}
