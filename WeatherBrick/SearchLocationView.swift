//
//  SearchLocationViewModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 24.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class SearchLocationView: UIView {
    weak var delegate: SearchLocationViewModelDelegate?
    
    private lazy var backgroundImageView = BackgraundImageView()
 
    lazy var searchController: UISearchController = {
        let tempSearchController = UISearchController(searchResultsController: nil)
        tempSearchController.obscuresBackgroundDuringPresentation = false
        tempSearchController.searchBar.placeholder = "Enter your location"
        tempSearchController.searchBar.delegate = delegate
    return tempSearchController
    }()
    
private(set) lazy var errorTextLabel = ErrorTextLabel()
      
    func createSearchLocationMainView() {
        addSubview(backgroundImageView)
    }
    
    func addErrorTextLabel(with text: String) {
        addSubview(errorTextLabel)
        errorTextLabel.setConstraints()
        errorTextLabel.text = text
    }
}

protocol SearchLocationViewModelDelegate: UISearchBarDelegate {
}
