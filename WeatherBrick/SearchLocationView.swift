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
    
    private(set) lazy var searchController: UISearchController = {
        let tempSearchController = UISearchController(searchResultsController: nil)
        tempSearchController.obscuresBackgroundDuringPresentation = false
        let attributedString = NSAttributedString(
            string: AppConstants.TitleFor.searchBarPlaceHolder,
            attributes: [
                NSAttributedString.Key.kern: -0.41,
                NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuLight, size: 16) ?? UIFont()
            ])
        tempSearchController.searchBar.searchTextField.attributedPlaceholder = attributedString
        tempSearchController.searchBar.delegate = searchBarDelegate
        return tempSearchController
    }()
    
    private(set) lazy var backButton: UIBarButtonItem = {
        let tempBackButton = UIBarButtonItem(
            title: AppConstants.TitleFor.backButtonTitle,
            style: .plain,
            target: self,
            action: #selector(delegateActions(_:)))
        return tempBackButton
    }()
    
    private(set) lazy var messageTextLabel = MessageTextLabel()
    private(set) lazy var containerView = UIView()
    
    lazy var userLocationButton: UserLocationButton = {
        let tempUserLocationButton = UserLocationButton()
        tempUserLocationButton.addTarget(
            self,
            action: #selector(delegateActions(_:)),
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
        containerView.addSubview(userLocationButton)
    }
    
    private func setAllConstraints() {
        setContainerViewConstraints()
        setMessageTextLabelConstarints()
        setUserLocationButtonConstraints()
        containerView.bottomAnchor.constraint(equalTo: userLocationButton.bottomAnchor).isActive = true
    }
    
    @objc private func delegateActions(_ sender: Any) {
        if sender as? UIBarButtonItem != nil {
            delegate?.backButtonPressed()
        } else {
            delegate?.userLocattionButtonPressed()
        }
    }
    
    private func setContainerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: AppConstants.Indent.left),
            containerView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: AppConstants.Indent.right)
        ])
    }
    
    private func setMessageTextLabelConstarints() {
        messageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageTextLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            messageTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            messageTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            messageTextLabel.heightAnchor.constraint(equalToConstant: 156)
        ])
    }
    
    private func setUserLocationButtonConstraints() {
        userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userLocationButton.topAnchor.constraint(equalTo: messageTextLabel.bottomAnchor, constant: 24),
            userLocationButton.centerXAnchor.constraint(equalTo: messageTextLabel.centerXAnchor),
            userLocationButton.widthAnchor.constraint(equalToConstant: userLocationButton.frame.width + 20)
        ])
    }
}

protocol SearchLocationViewModelDelegate: AnyObject {
    func userLocattionButtonPressed()
    func backButtonPressed()
}
