//
//  LocationButton.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class LocationButton: UIButton {
    var widthAnchorConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        let attributedTitle = NSAttributedString(
            string: "Choose your location",
            attributes: [
                NSAttributedString.Key.kern: -0.41,
                NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuRegular, size: 17) ?? UIFont()
            ])
        setAttributedTitle(attributedTitle, for: .normal)
        sizeToFit()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.height / 2
    }
    
    func updateAppearance(_ title: String) {
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.kern: -0.41,
                NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuMedium, size: 17) ?? UIFont()
            ])
        setAttributedTitle(attributedTitle, for: .normal)
        layer.borderWidth = 0
        layer.cornerRadius = 0
        sizeToFit()
        widthAnchorConstraint.constant = frame.width
    }
    
    func setConstraints() {
        guard let superview = superview as? WeatherMainView else { return }
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchorConstraint = widthAnchor.constraint(equalToConstant: frame.width + 20)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: 700),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            widthAnchorConstraint
        ])
    }
}
