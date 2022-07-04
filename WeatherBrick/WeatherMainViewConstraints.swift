//
//  WeatherMainViewConstraintsExtension.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 19.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

extension WeatherMainView {
    func setConstraints() {
        backgroundImageView.setConstraints()
        setTemperatureLabelConstraints()
        setConditionLabelConstraints()
        setWindSpeedLabelConstraints()
        locationButton.setConstraints()
        setCircleAnimationConstraints()
        setErrorMessageTextLabelConstraint()
        setPopUpWindowConstraints()
    }
    
    func setGeoLocationIconConstraints() {
        setGeoLocationViewConstraints()
    }
    
    func setSearchIconConstraints() {
        setSearchIconViewConstraints()
    }
    
    private func setTemperatureLabelConstraints() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: SizesConstants.Indent.left),
            temperatureLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: UIScreen.main.bounds.height * CGFloat(AppConstants.bigScreenSize ? 0.55 : 0.57)),
            temperatureLabel.heightAnchor.constraint(equalToConstant: AppConstants.bigScreenSize ? 126 : 95),
            temperatureLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: .zero)
        ])
    }
    
    private func setConditionLabelConstraints() {
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conditionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: SizesConstants.Indent.left),
            conditionLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: SizesConstants.Indent.right),
            conditionLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: UIScreen.main.bounds.height * CGFloat(AppConstants.bigScreenSize ? 0.66 : 0.67)),
            conditionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: .zero),
            conditionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: .zero)
        ])
    }
    
    private func setWindSpeedLabelConstraints() {
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            windSpeedLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor),
            windSpeedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: SizesConstants.Indent.left),
            windSpeedLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: .zero),
            windSpeedLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: .zero)
        ])
    }
    
    private func setCircleAnimationConstraints() {
        circleAnimation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleAnimation.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor),
            circleAnimation.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleAnimation.heightAnchor.constraint(equalToConstant: AppConstants.bigScreenSize ? 80 : 40),
            circleAnimation.widthAnchor.constraint(equalToConstant: SizesConstants.AnimationSize.width)
        ])
    }
    
    private func setErrorMessageTextLabelConstraint() {
        errorMessageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorMessageTextLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: SizesConstants.Indent.left),
            errorMessageTextLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: SizesConstants.Indent.right),
            errorMessageTextLabel.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -5),
            errorMessageTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: .zero)
        ])
    }
    
    private func setGeoLocationViewConstraints() {
        geoLocationImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            geoLocationImageView.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            geoLocationImageView.trailingAnchor.constraint(equalTo: locationButton.leadingAnchor, constant: -5),
            geoLocationImageView.widthAnchor.constraint(equalToConstant: SizesConstants.IconSize.width),
            geoLocationImageView.heightAnchor.constraint(equalTo: geoLocationImageView.widthAnchor)
        ])
    }
    
    private func setSearchIconViewConstraints() {
        searchIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIconImageView.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            searchIconImageView.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: 5),
            searchIconImageView.widthAnchor.constraint(equalToConstant: SizesConstants.IconSize.width),
            searchIconImageView.heightAnchor.constraint(equalTo: searchIconImageView.widthAnchor)
        ])
    }
    
    private func setPopUpWindowConstraints() {
        popUpWindow.translatesAutoresizingMaskIntoConstraints = false
        axisYConstraint =
        popUpWindow.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: UIScreen.main.bounds.height * 0.64)
        NSLayoutConstraint.activate([
            axisYConstraint,
            popUpWindow.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            popUpWindow.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            popUpWindow.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45)
        ])
    }
}
