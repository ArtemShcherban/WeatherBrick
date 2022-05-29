//
//  SearchLocationViewModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 24.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class SearchLocationViewModel: UIView {
    weak var delegate: SearchLocationViewModelDelegate?
//    weak var tableViewDelegate: UITableViewDelegate?
//    weak var tableViewDataSource: UITableViewDataSource?
    
    private lazy var backgroundImageView = BackgraundImageView()
 
    lazy var searchController: UISearchController = {
        let tempSearchController = UISearchController(searchResultsController: nil)
        tempSearchController.obscuresBackgroundDuringPresentation = false
        tempSearchController.searchBar.placeholder = "Enter your location"
        tempSearchController.searchBar.delegate = delegate
       return tempSearchController
    }()
    
//    private lazy var searchBarField: UISearchBar = {
//        let tempSearchBarField = UISearchBar()
//        tempSearchBarField.searchBarStyle = .minimal
//        tempSearchBarField.barStyle = .default
//        tempSearchBarField.isTranslucent = true
//        tempSearchBarField.barTintColor = .white
//        if let textField = tempSearchBarField.value(forKey: "searchTextField") as? UITextField {
//            textField.backgroundColor = AppConstants.Color.skyBlue
//        }
//        
//        tempSearchBarField.delegate = delegate
//        return tempSearchBarField
//    }()
    
//    lazy var tableView: UITableView = {
//        let tempTableView = UITableView()
//        tempTableView.delegate = tableViewDelegate
//        tempTableView.dataSource = tableViewDataSource
//        tempTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        tempTableView.backgroundColor = .green
//        return tempTableView
//    }()
    
    func createSearchLocationMainView() {
        addSubview(backgroundImageView)
//        addSubview(searchBarField)
        
//        setSearchTextFieldConstraints()
    }
    
//    func createTableView() {
//        addSubview(tableView)
//        setTableViewConstraints()
//    }
    
//    func setSearchTextFieldConstraints() {
//        searchBarField.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            searchBarField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
//            searchBarField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
//            searchBarField.topAnchor.constraint(equalTo: self.topAnchor, constant: 200),
//            searchBarField.heightAnchor.constraint(equalToConstant: 58)
//        ])
//    }
//    
//    func setTableViewConstraints() {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//        ])
//    }
}

protocol SearchLocationViewModelDelegate: UISearchBarDelegate {
    }
