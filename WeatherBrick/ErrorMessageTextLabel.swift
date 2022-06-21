//
//  ErrorMessageTextLabel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 17.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class ErrorMessageTextLabel: UILabel {
    var retrieveError = String() {
        willSet {
            if  retrieveError != newValue && !newValue.isEmpty {
                willChangeStringTo(newValue)
            }
        }
    }
    
    lazy var isActive = false {
        didSet {
            if !isActive {
                retrieveError = String()
                fadeTransition(0.2)
                text = retrieveError
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func willChangeStringTo(_ value: String) {
        isActive = true
        fadeTransition(0.5)
        text = value
    }
    
    func configure() {
        let attributedString = NSAttributedString(
            string:
                " ",
            attributes: [
                NSAttributedString.Key.font: UIFont(
                    name: AppConstants.Font.ubuntuLight,
                    size: AppConstants.bigScreenSize ? 15 : 13) ?? UIFont(),
                NSAttributedString.Key.kern: -0.41,
                NSAttributedString.Key.foregroundColor: AppConstants.Color.lightGraphite
            ])
        textAlignment = .center
        attributedText = attributedString
        numberOfLines = 2
        alpha = 1
        backgroundColor = .clear
    }
}
