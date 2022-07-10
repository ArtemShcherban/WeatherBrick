//
//  SearchLocationViewModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 24.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class SearchLocationView: UIView {
    weak var delegate: SearchLocationViewDelegate?
    weak var searchBarDelegate: UISearchBarDelegate?
    
    private(set) lazy var backgroundImageView = BackgroundImageView()
    
    private(set) lazy var searchController: UISearchController = {
        let tempSearchController = UISearchController(searchResultsController: nil)
        tempSearchController.obscuresBackgroundDuringPresentation = false
        let attributedString = NSAttributedString(
            string: TitlesConstants.searchBarPlaceHolder,
            attributes: [
                NSAttributedString.Key.kern: -0.41,
                NSAttributedString.Key.font: UIFont(name: FontsConstants.ubuntuLight, size: 16) ?? UIFont()
            ])
        tempSearchController.searchBar.searchTextField.attributedPlaceholder = attributedString
        tempSearchController.searchBar.delegate = searchBarDelegate
        tempSearchController.searchBar.searchTextField.accessibilityIdentifier = IdentifiersConstants.searchTextField
        return tempSearchController
    }()
    
    private(set) lazy var backButton: UIBarButtonItem = {
        let tempBackButton = UIBarButtonItem(
            title: TitlesConstants.backButtonTitle,
            style: .plain,
            target: self,
            action: #selector(backButtonDelegateAction))
        tempBackButton.accessibilityIdentifier = IdentifiersConstants.backButton
        return tempBackButton
    }()
    
    private(set) lazy var messageTextLabel = MessageTextLabel()
    private(set) lazy var containerView = UIView()
    private(set) lazy var circleAnimation = CircleAnimationView()
    
    private(set) lazy var userLocationButton: UserLocationButton = {
        let tempUserLocationButton = UserLocationButton()
        tempUserLocationButton.addTarget(
            self,
            action: #selector(userLocationButtonDelegateAction),
            for: .touchUpInside)
        return tempUserLocationButton
    }()
    
    func createSearchLocationMainView() {
        addSubviews()
        setAllConstraints()
    }
    
    private func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(containerView)
        containerView.addSubview(messageTextLabel)
        messageTextLabel.addSubview(circleAnimation)
        containerView.addSubview(userLocationButton)
    }
    
    func startCircleAnimation() {
        fadeTransition(0.2)
        messageTextLabel.text = String()
        circleAnimation.start()
    }
    
    @objc private func userLocationButtonDelegateAction() {
        delegate?.userLocattionButtonPressed()
    }
    
    @objc private func backButtonDelegateAction() {
        delegate?.backButtonPressed()
    }
}

protocol SearchLocationViewDelegate: AnyObject {
    func userLocattionButtonPressed()
    func backButtonPressed()
}
