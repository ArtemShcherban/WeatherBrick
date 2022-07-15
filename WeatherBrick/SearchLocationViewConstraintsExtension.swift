//
//  SearchLocationViewConstraintsExtension.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 19.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

extension SearchLocationView {
    func setAllConstraints() {
        backgroundImageView.setConstraints()
        setContainerViewConstraints()
        setMessageTextLabelConstarints()
        setUserLocationButtonConstraints()
        setCircleAnimationConstrints()
        containerView.bottomAnchor.constraint(equalTo: userLocationButton.bottomAnchor).isActive = true
    }
    
    private func setContainerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: SizesConstants.Indent.left),
            containerView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: SizesConstants.Indent.right)
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
            userLocationButton.widthAnchor.constraint(equalToConstant: userLocationButton.frame.width)
        ])
    }
    
    private func setCircleAnimationConstrints() {
        circleAnimation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleAnimation.widthAnchor.constraint(equalToConstant: SizesConstants.AnimationSize.width),
            circleAnimation.heightAnchor.constraint(equalTo: circleAnimation.widthAnchor ),
            circleAnimation.centerXAnchor.constraint(equalTo: messageTextLabel.centerXAnchor),
            circleAnimation.centerYAnchor.constraint(equalTo: messageTextLabel.centerYAnchor)
        ])
    }
}
