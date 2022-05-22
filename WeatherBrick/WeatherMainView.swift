//
//  WeatherMainView.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 20.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
final class WeatherMainView: UIView {
    private lazy var axisYConstraint = NSLayoutConstraint()
    
    weak var delegate: WeatherMainViewDelegate?
    static let shared = WeatherMainView()
    
    private lazy var backgroundImageView: UIImageView = {
        let tempbackgroundImageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height))
        tempbackgroundImageView.isUserInteractionEnabled = true
        tempbackgroundImageView.backgroundColor = .white
        tempbackgroundImageView.image = UIImage(named: AppConstants.Image.background)
        return tempbackgroundImageView
    }()
    
    private lazy var stoneImageView: UIImageView = {
        let tempStoneImageView = UIImageView()
        tempStoneImageView.image = UIImage(named: "image_stone_normal")
        return tempStoneImageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let tempTemperatureLabel = UILabel(frame: (CGRect(x: 16, y: 461, width: 124, height: 126)))
        tempTemperatureLabel.text = "12°"
        tempTemperatureLabel.font = UIFont(name: AppConstants.Font.ubuntuRegular, size: 83)
        return tempTemperatureLabel
    }()
    
    private lazy var conditionLabel: UILabel = {
        let tempConditionLabel = UILabel(frame: CGRect(x: 16, y: 558, width: 124, height: 58))
        tempConditionLabel.text = "sunny"
        tempConditionLabel.font = UIFont(name: AppConstants.Font.ubuntuLight, size: 36)
        return tempConditionLabel
    }()
    
    private lazy var locationButton: UIButton = {
        let tempLocationButton = UIButton()
        tempLocationButton.setTitle("Krakow, Poland", for: .normal)
        tempLocationButton.setTitleColor(AppConstants.Color.graphite, for: .normal)
        return tempLocationButton
    }()
    
    private lazy var geoLocationView: UIImageView = {
        let tempGeoLocationLabel = UIImageView()
        tempGeoLocationLabel.image = UIImage(named: "icon_location")
        return tempGeoLocationLabel
    }()
    
    private lazy var searchIconView: UIImageView = {
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
        addSubview(geoLocationView)
        addSubview(searchIconView)
        addSubview(stoneImageView)
        addSubview(popUpWindow)
        setLocationLabelConstraints()
        setGeoLocationViewConstraints()
        setSearchIconViewConstraints()
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
    
    func setLocationLabelConstraints() {
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 700),
            locationButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            locationButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            locationButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func setGeoLocationViewConstraints() {
        geoLocationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            geoLocationView.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            geoLocationView.trailingAnchor.constraint(equalTo: locationButton.leadingAnchor, constant: -5),
            geoLocationView.widthAnchor.constraint(equalToConstant: 16),
            geoLocationView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func setSearchIconViewConstraints() {
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIconView.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            searchIconView.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: 5),
            searchIconView.widthAnchor.constraint(equalToConstant: 16),
            searchIconView.heightAnchor.constraint(equalToConstant: 16)
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
        popUpWindow.isActive = true
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
                self.layoutIfNeeded()
        }
    }
    
    func animatePopUpWindowOut() {
        popUpWindow.isActive = false
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
                self.layoutIfNeeded()
        }
    }
}

protocol WeatherMainViewDelegate: AnyObject {
    func locationButtonPressed()
    func testButtonPressed()
}
