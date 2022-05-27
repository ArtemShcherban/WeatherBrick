//
//  LocationButton.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class LocationButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        setButtonTitle()
    }
    
    func setButtonTitle(_ title: String = "Choose your location") {
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.kern: -0.41,
            NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuMedium, size: 17) ?? UIFont()
        ])
        setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func setConstraints() {
        guard let superView = superview as? WeatherMainView else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor, constant: 700),
            centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
