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
    
    lazy var axisYConstraint = NSLayoutConstraint()
    
    private(set) lazy var backgroundImageView = BackgraundImageView()
    lazy var stoneImageView = StoneImageView()
    lazy var alphaValues: [Double] = []
    
    private(set) lazy var temperatureLabel: UILabel = {
        let tempTemperatureLabel = UILabel()
        tempTemperatureLabel.font = UIFont(
            name: AppConstants.Font.ubuntuRegular,
            size: AppConstants.bigScreenSize ? 83 : 63) ?? UIFont()
        return tempTemperatureLabel
    }()
    
    private(set) lazy var conditionLabel: UILabel = {
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
    
    private(set) lazy var windSpeedLabel: UILabel = {
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
    
    private(set) lazy var circleAnimation = CircleAnimationView()
    private(set) lazy var errorMessageTextLabel = ErrorMessageTextLabel()
    private(set) lazy var locationButton = LocationButton()
    
    private(set) lazy var geoLocationImageView: UIImageView = {
        let tempGeoLocationLabel = UIImageView()
        tempGeoLocationLabel.image = AppConstants.Icon.location
        return tempGeoLocationLabel
    }()
    
    private(set) lazy var searchIconImageView: UIImageView = {
        let tempSearchIconView = UIImageView()
        tempSearchIconView.image = AppConstants.Icon.search
        return tempSearchIconView
    }()
    
    private(set) lazy var popUpWindow: PopUpWindow = {
        let view = PopUpWindow()
        return view
    }()
    
    func createMainView() {
        addSubviews()
        addSwipeGesture()
        addTargetForLocationButton()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(stoneImageView)
        addSubview(temperatureLabel)
        addSubview(conditionLabel)
        addSubview(windSpeedLabel)
        addSubview(locationButton)
        addSubview(circleAnimation)
        addSubview(errorMessageTextLabel)
        addSubview(popUpWindow)
    }
    
    private func addSwipeGesture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(delegateAction))
        swipe.direction = .down
        swipe.location(in: stoneImageView)
        stoneImageView.addGestureRecognizer(swipe)
    }
    
    private func addTargetForLocationButton() {
        locationButton.addTarget(self, action: #selector(delegateAction), for: .touchUpInside)
    }
    
    @objc private func delegateAction(_ sender: Any) {
        if sender is UIButton {
            delegate?.locationButtonPressed()
        } else {
            delegate?.didSwipe()
        }
    }
    
    func updateWeather(with myWeather: WeatherInfo ) {
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
            setGeoLocationIconConstraints()
        case false:
            if geoLocationImageView.superview === self {
                geoLocationImageView.removeFromSuperview()
            }
            insertSubview(searchIconImageView, belowSubview: popUpWindow)
            setSearchIconConstraints()
        }
    }
}

protocol WeatherMainViewDelegate: AnyObject {
    func didSwipe()
    func locationButtonPressed()
}
