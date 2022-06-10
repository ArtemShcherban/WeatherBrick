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
    weak var searchBarDelegate: UISearchBarDelegate?
    
    private lazy var backgroundImageView = BackgraundImageView()
 
    lazy var searchController: UISearchController = {
        let tempSearchController = UISearchController(searchResultsController: nil)
        tempSearchController.obscuresBackgroundDuringPresentation = false
        tempSearchController.searchBar.placeholder = "Enter your location"
        tempSearchController.searchBar.delegate = searchBarDelegate
    return tempSearchController
    }()
    
    private(set) lazy var errorTextLabel = ErrorTextLabel()
    
    lazy var userLocationButton: UserLocationButton = {
        let tempUserLocationButton = UserLocationButton()
        tempUserLocationButton.addTarget(
            delegate,
            action: #selector(delegate?.userLocattionButtonPressed),
            for: .touchUpInside)
        return tempUserLocationButton
    }()
      
    func createSearchLocationMainView() {
        addSubview(backgroundImageView)
        addSubview(userLocationButton)
        addSubview(errorTextLabel)
        errorTextLabel.setConstraints()
        userLocationButton.setConstraints()
    }
    
    func addErrorTextLabel(with text: String) {
        errorTextLabel.text = text
        errorTextLabel.isActive = true
    }
}

@objc protocol SearchLocationViewModelDelegate: AnyObject {
func userLocattionButtonPressed()
}
