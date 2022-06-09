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
    
    lazy var userLocationButton: LocationButton = {
        let tempUserLocationButton = LocationButton()
        tempUserLocationButton.backgroundColor = .clear
        tempUserLocationButton.isSelected = false
        tempUserLocationButton.setButtonTitle("Find your location")
        tempUserLocationButton.setTitleColor(AppConstants.Color.lightGraphite, for: .normal)
        tempUserLocationButton.layer.cornerRadius = 18
        tempUserLocationButton.layer.borderColor = AppConstants.Color.lightGraphite.cgColor
        tempUserLocationButton.layer.borderWidth = 2
        tempUserLocationButton.titleLabel?.numberOfLines = 2
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
        setUserLocationButtonConstraints()
    }
    
    func addErrorTextLabel(with text: String) {
        errorTextLabel.text = text
        errorTextLabel.isActive = true
    }
    
    func setUserLocationButtonConstraints() {
        userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userLocationButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 100),
            userLocationButton.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: (AppConstants.Indent.left * 4)),
            userLocationButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: (AppConstants.Indent.right * 4)),
            userLocationButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}

@objc protocol SearchLocationViewModelDelegate: AnyObject {
func userLocattionButtonPressed()
}
