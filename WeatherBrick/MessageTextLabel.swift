//
//  MessageTextLabel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 30.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import Lottie

final class MessageTextLabel: UILabel {
    lazy var retrieveError = String()
    private let informationString = AppConstants.inputFormats
    
    lazy var isActive = false {
        didSet {
            if isActive == true {
                messageTextAnimation {
                    createErrorAttributedString()
                }
            } else {
                messageTextAnimation {
                    createFormatsAttributedString()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        createFormatsAttributedString()
    }
    
    private func messageTextAnimation(_ updateAttributeString: () -> Void) {
        fadeTransition(0.5)
        updateAttributeString()
    }
    
    private func createFormatsAttributedString() {
        textAlignment = .center
        numberOfLines = 0
        let attributedString = NSMutableAttributedString(
            string: informationString,
            attributes: [
                NSAttributedString.Key.kern: -0.41,
                NSAttributedString.Key.font:
                    UIFont(name: AppConstants.Font.ubuntuLight, size: 15) ?? UIFont(),
                NSAttributedString.Key.foregroundColor: AppConstants.Color.lightGraphite
            ])
        let cityRange = NSRange(location: 0, length: 41)
        let coordinatesRange = NSRange(location: 74, length: 18)
        let extraAttribute = [
            NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuMedium, size: 15) ?? UIFont()
        ]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(
            location: 65,
            length: 2))
        attributedString.addAttributes(extraAttribute, range: cityRange)
        attributedString.addAttributes(extraAttribute, range: coordinatesRange)
        attributedText = attributedString
    }
    
    private func createErrorAttributedString() {
        textAlignment = .center
        numberOfLines = 2
        let attributedString = NSMutableAttributedString(
            string: retrieveError,
            attributes: [
                NSAttributedString.Key.font:
                    UIFont(name: AppConstants.Font.ubuntuRegular, size: 15) ?? UIFont(),
                NSAttributedString.Key.foregroundColor: AppConstants.Color.lightGraphite
            ])
        attributedText = attributedString
    }
}
