//
//  LocationButton.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import DeviceKit

final class LocationButton: UIButton {
    private lazy var widthAnchorConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    var isActive = true {
        didSet {
            setButtonEnabled()
        }
    }
    
    private func configure() {
        let attributedTitle = NSAttributedString(
            string: AppConstants.TitleFor.locationButton,
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
    
    private func setButtonEnabled() {
        fadeTransition(0.5)
        alpha = isActive ? 1 : 0.2
        isEnabled = isActive
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
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false
            widthAnchorConstraint = widthAnchor.constraint(equalToConstant: frame.width + 20)
            NSLayoutConstraint.activate([
                topAnchor.constraint(
                    equalTo: superview.topAnchor,
                    constant: UIScreen.main.bounds.size.height * CGFloat(AppConstants.bigScreenSize ? 0.83 : 0.8)),
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                widthAnchorConstraint
            ])
        }
    }
}
