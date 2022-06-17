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
        didSet {
            if oldValue.isEmpty {
                isActive = true
            }
        }
    }
    
    lazy var isActive = false {
        didSet {
            if isActive {
                fadeTransition(0.5)
                text = retrieveError
            } else {
                fadeTransition(0.5)
                text = String()
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
    
    func configure() {
        let attributedString = NSAttributedString(
            string:
                " ",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuLight, size: 15) ?? UIFont(),
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
