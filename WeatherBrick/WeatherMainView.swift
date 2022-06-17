//
//  WeatherMainView.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 20.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import DeviceKit

final class WeatherMainView: UIView {
    static let shared = WeatherMainView()
    weak var delegate: WeatherMainViewDelegate?
    
    private lazy var axisYConstraint = NSLayoutConstraint()
    
    private lazy var backgroundImageView = BackgraundImageView()
    
    lazy var stoneImageView = StoneImageView()
    lazy var alphaValues: [Double] = []
    
    lazy var temperatureLabel: UILabel = {
        let tempTemperatureLabel = UILabel()
        tempTemperatureLabel.font = UIFont(
            name: AppConstants.Font.ubuntuRegular,
            size: AppConstants.bigScreenSize ? 83 : 63) ?? UIFont()
        return tempTemperatureLabel
    }()
    
    lazy var conditionLabel: UILabel = {
        let tempConditionLabel = UILabel(frame: CGRect(x: 16, y: 558, width: 124, height: 58))
        let attributedString = NSAttributedString(string: " ", attributes: [
            NSAttributedString.Key.kern: -0.41,
            NSAttributedString.Key.font: UIFont(
                name: AppConstants.Font.ubuntuLight,
                size: AppConstants.bigScreenSize ? 36 : 27) ?? UIFont()
        ])
        tempConditionLabel.attributedText = attributedString
        tempConditionLabel.numberOfLines = 3
        return tempConditionLabel
    }()
    
    lazy var windSpeedLabel: UILabel = {
        let tempWindSpeedLabel = UILabel()
        let attributedString = NSAttributedString(string: " ", attributes: [
            NSAttributedString.Key.kern: -0.41,
            NSAttributedString.Key.font: UIFont(
                name: AppConstants.Font.ubuntuLight,
                size: AppConstants.bigScreenSize ? 20 : 15) ?? UIFont()
        ])
        tempWindSpeedLabel.attributedText = attributedString
        return tempWindSpeedLabel
    }()
    
    lazy var errorMessageTextLabel = ErrorMessageTextLabel()
    
    lazy var locationButton = LocationButton()
    
    lazy var geoLocationImageView: UIImageView = {
        let tempGeoLocationLabel = UIImageView()
        tempGeoLocationLabel.image = UIImage(named: "icon_location")
        return tempGeoLocationLabel
    }()
    
    lazy var searchIconImageView: UIImageView = {
        let tempSearchIconView = UIImageView()
        tempSearchIconView.image = UIImage(named: "icon_search")
        return tempSearchIconView
    }()
    
    lazy var popUpWindow: PopUpWindow = {
        let view = PopUpWindow()
        return view
    }()
    
    func createMainView() {
        addSubviews()
        addSwipeGesture()
        addTargetForLocationButton()
        setConstraints()
    }
    
    func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(stoneImageView)
        addSubview(temperatureLabel)
        addSubview(conditionLabel)
        addSubview(windSpeedLabel)
        addSubview(locationButton)
        addSubview(errorMessageTextLabel)
        addSubview(popUpWindow)
    }
    
    func setConstraints() {
        setTemperatureLabelConstraints()
        setConditionLabelConstraints()
        setWindSpeedLabelConstraints()
        locationButton.setConstraints()
        setErrorMessageTextLabelConstraint()
        setPopUpWindowConstraints()
    }
    
    func addSwipeGesture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(delegateAction))
        swipe.direction = .down
        swipe.location(in: stoneImageView)
        stoneImageView.addGestureRecognizer(swipe)
    }
    
    func addTargetForLocationButton() {
        locationButton.addTarget(self, action: #selector(delegateAction), for: .touchUpInside)
    }
    
    @objc func delegateAction(_ sender: Any) {
        if sender is UIButton {
            delegate?.locationButtonPressed()
        } else {
            delegate?.didSwipe()
        }
    }
    
    func updateWeather(with myWeather: MyWeather ) {
        temperatureLabel.text = myWeather.temperature
        conditionLabel.text = myWeather.conditionDetails.lowercased()
        locationButton.isEnabled = true
        locationButton.updateAppearance("\(myWeather.city), \(myWeather.flag) \(myWeather.country) ")
        windSpeedLabel.text = "wind: \(myWeather.wind) m/s."
        if (Int(myWeather.wind) ?? 0) >= 8 {
            stoneImageView.windAnimation()
        } else {
            stoneImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
        stoneImageView.image = UIImage(named: myWeather.stoneImage)
        if AppConstants.Precipitation.atmosphere.contains(myWeather.conditionMain) {
            stoneImageView.alpha = 0.3
        } else {
            stoneImageView.alpha = 1
        }
    }
    
    func setIconFor(_ geoLocation: Bool) {
        switch geoLocation {
        case true:
            if searchIconImageView.superview === self {
                searchIconImageView.removeFromSuperview()
            }
            insertSubview(geoLocationImageView, belowSubview: popUpWindow)
            setGeoLocationViewConstraints()
        case false:
            if geoLocationImageView.superview === self {
                geoLocationImageView.removeFromSuperview()
            }
            insertSubview(searchIconImageView, belowSubview: popUpWindow)
            setSearchIconViewConstraints()
        }
    }
    
    func setTemperatureLabelConstraints() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            temperatureLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: UIScreen.main.bounds.height * CGFloat(AppConstants.bigScreenSize ? 0.55 : 0.57)),
            temperatureLabel.heightAnchor.constraint(equalToConstant: AppConstants.bigScreenSize ? 126 : 95),
            temperatureLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }
    
    func setConditionLabelConstraints() {
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conditionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            conditionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            conditionLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: UIScreen.main.bounds.height * CGFloat(AppConstants.bigScreenSize ? 0.66 : 0.67)),
            conditionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            conditionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }
    
    func setWindSpeedLabelConstraints() {
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            windSpeedLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor),
            windSpeedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: AppConstants.Indent.left),
            windSpeedLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            windSpeedLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }
    
    func setErrorMessageTextLabelConstraint() {
        errorMessageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorMessageTextLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: AppConstants.Indent.left),
            errorMessageTextLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: AppConstants.Indent.right),
            errorMessageTextLabel.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -5),
            errorMessageTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }
    
    func setGeoLocationViewConstraints() {
        geoLocationImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            geoLocationImageView.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            geoLocationImageView.trailingAnchor.constraint(equalTo: locationButton.leadingAnchor, constant: -5),
            geoLocationImageView.widthAnchor.constraint(equalToConstant: 16),
            geoLocationImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func setSearchIconViewConstraints() {
        searchIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIconImageView.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            searchIconImageView.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: 5),
            searchIconImageView.widthAnchor.constraint(equalToConstant: 16),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func setPopUpWindowConstraints() {
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

extension WeatherMainView {
    func animatePopUpWindowIn() {
        self.axisYConstraint.constant = 0
        UIView.animate(
            withDuration: 1.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut) {
                for index in 1..<self.subviews.count - 1 {
                    self.alphaValues.append(self.subviews[index].alpha)
                    self.subviews[index].alpha = 0
                }
                self.popUpWindow.applyGradientAnimation()
                self.popUpWindow.isActive = true
                self.layoutIfNeeded()
        }
    }
    
    func animatePopUpWindowOut() {
        self.axisYConstraint.constant = UIScreen.main.bounds.height * 0.64
        UIView.animate(
            withDuration: 1.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut) {
                for index in 1..<self.subviews.count - 1 {
                    self.subviews[index].alpha = self.alphaValues[index - 1]
                }
                self.alphaValues = []
                self.popUpWindow.applyGradientAnimation()
                self.popUpWindow.isActive = false
                self.layoutIfNeeded()
        }
    }
}

protocol WeatherMainViewDelegate: AnyObject {
    func didSwipe()
    func locationButtonPressed()
}
