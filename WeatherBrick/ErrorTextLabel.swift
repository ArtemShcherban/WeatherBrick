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
    
    var isActive = false {
        didSet {
            if isActive != oldValue {
                applyAnimation()
            }
        }
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
        layer.opacity = 0
    }
    
    func applyAnimation() {
        let labelAlpha = CABasicAnimation(keyPath: "opacity")
        labelAlpha.duration = 0.5
        labelAlpha.fromValue = layer.opacity
        if isActive {
            labelAlpha.toValue = layer.opacity = 1
            layer.add(labelAlpha, forKey: nil)
        } else {
            labelAlpha.toValue = layer.opacity = 0
            layer.add(labelAlpha, forKey: nil)
        }
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
