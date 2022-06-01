//
//  ErrorTextLabel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 30.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class ErrorTextLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        backgroundColor = .clear
        textAlignment = .center
        numberOfLines = 2
        let attributedString = NSAttributedString(
            string: " ",
            attributes: [
                NSAttributedString.Key.font:
                    UIFont(name: AppConstants.Font.ubuntuRegular, size: 15) ?? UIFont(),
                NSAttributedString.Key.foregroundColor: AppConstants.Color.lightGraphite
            ])
        attributedText = attributedString
    }
    
    func setConstraints() {
        if let superview = superview as? SearchLocationView {
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 30),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: AppConstants.Indent.left),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: AppConstants.Indent.right),
                heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
            ])
        }
    }
}
