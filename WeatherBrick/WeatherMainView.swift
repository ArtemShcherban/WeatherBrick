//
//  WeatherMainView.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 20.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
final class WeatherMainView: UIView {
    static let shared = WeatherMainView()
    weak var delegate: WeatherMainViewDelegate?
    
    private lazy var axisYConstraint = NSLayoutConstraint()
    
    private lazy var backgroundImageView = BackgraundImageView()
    
    lazy var stoneImageView: UIImageView = {
        let tempStoneImageView = UIImageView()
        tempStoneImageView.alpha = 1
        return tempStoneImageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let tempTemperatureLabel = UILabel(frame: (CGRect(x: 16, y: 461, width: 124, height: 126)))
        tempTemperatureLabel.font = UIFont(name: AppConstants.Font.ubuntuRegular, size: 83)
        return tempTemperatureLabel
    }()
    
    lazy var conditionLabel: UILabel = {
        let tempConditionLabel = UILabel(frame: CGRect(x: 16, y: 558, width: 124, height: 58))
        let attributedString = NSAttributedString(string: " ", attributes: [
            NSAttributedString.Key.kern: -0.41,
            NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuLight, size: 36) ?? UIFont()
        ])
        tempConditionLabel.attributedText = attributedString
        tempConditionLabel.numberOfLines = 3
        return tempConditionLabel
    }()
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
        addSubview(backgroundImageView)
        addSubview(temperatureLabel)
        addSubview(conditionLabel)
        addSubview(locationButton)
        addSubview(stoneImageView)
        addSubview(popUpWindow)
        
        //        createGradient()
        setConditionLabelConstraints()
        locationButton.setConstraints()
        setStoneImageViewConstraints()
        setPopUpWindowConstraints()
        addTargetForLocationButton()
    }
    
    func addTargetForLocationButton() {
        locationButton.addTarget(self, action: #selector(delegateAction), for: .touchUpInside)
    }
    
    @objc func delegateAction(_ sender: UIButton) {
        delegate?.locationButtonPressed()
    }
    
    func updateWeather(with myWeather: MyWeather ) {
        temperatureLabel.text = myWeather.temperature
        conditionLabel.text = myWeather.conditionDetails.lowercased()
        locationButton.setButtonTitle("\(myWeather.city), \(myWeather.flag) \(myWeather.country) ")
        stoneImageView.image = UIImage(named: myWeather.stoneImage)
        if AppConstants.Precipitation.atmosphere.contains(myWeather.conditionMain) {
            stoneImageView.alpha = 0.3
        } else {
            stoneImageView.alpha = 1
        }
    }
    
    func setIcon(for locator: Bool) {
        switch locator {
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
    
    func setConditionLabelConstraints() {
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conditionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            conditionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            conditionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 558),
            conditionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            conditionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
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
    
    func setStoneImageViewConstraints() {
        stoneImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stoneImageView.topAnchor.constraint(equalTo: self.topAnchor),
            stoneImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setPopUpWindowConstraints() {
        popUpWindow.translatesAutoresizingMaskIntoConstraints = false
        axisYConstraint = popUpWindow.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 540)
        axisYConstraint.isActive = true
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
                    self.subviews[index].alpha = 0
                }
                self.popUpWindow.applyGradientAnimation()
                self.popUpWindow.isActive = true
                self.layoutIfNeeded()
        }
    }
    
    func animatePopUpWindowOut() {
        self.axisYConstraint.constant = 540
        UIView.animate(
            withDuration: 1.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut) {
                for index in 1..<self.subviews.count - 1 {
                    self.subviews[index].alpha = 1
                }
                self.popUpWindow.applyGradientAnimation()
                self.popUpWindow.isActive = false
                self.layoutIfNeeded()
        }
    }
}

protocol WeatherMainViewDelegate: AnyObject {
    func locationButtonPressed()
    func testButtonPressed()
}
