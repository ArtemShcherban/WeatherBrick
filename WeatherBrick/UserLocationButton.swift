//
//  UserLocationButton.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 10.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class UserLocationButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        backgroundColor = .clear
        isSelected = false
        let attributedTitle = NSAttributedString(string: AppConstants.TitleFor.userLocationButton, attributes: [
            NSAttributedString.Key.kern: -0.41,
            NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuMedium, size: 17) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: AppConstants.Color.lightGraphite
        ])
        setAttributedTitle(attributedTitle, for: .normal)
        sizeToFit()
        layer.cornerRadius = frame.height / 2
        layer.borderColor = AppConstants.Color.lightGraphite.cgColor
        layer.borderWidth = 2
    }
    
//    func setConstraints() {
//        if let superview = superview as? SearchLocationView {
//            translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                topAnchor.constraint(equalTo: superview.messageTextLabel.bottomAnchor, constant: 24),
//                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
//                widthAnchor.constraint(equalToConstant: frame.width + 20)
//            ])
//        }
//    }
//
//    func setConstraints() {
//        if let superview = superview as? MessageContainerView {
//            translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                topAnchor.constraint(equalTo: superview.messageTextLabel.bottomAnchor, constant: 24),
//                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
//                widthAnchor.constraint(equalToConstant: frame.width + 20)
//            ])
//        }
//    }
}
