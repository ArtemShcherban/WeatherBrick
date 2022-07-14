//
//  UserLocationButton.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 10.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class UserLocationButton: UIButton {
    let widthConstraint = NSLayoutConstraint()
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
        isSelected = false
        let attributedTitle = NSAttributedString(string: TitlesConstants.userLocationButton, attributes: [
            NSAttributedString.Key.kern: -0.41,
            NSAttributedString.Key.font: UIFont(name: FontsConstants.ubuntuMedium, size: 17) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: ColorConstants.lightGraphite
        ])
        setAttributedTitle(attributedTitle, for: .normal)
        sizeToFit()
        layer.cornerRadius = frame.height / 2
        layer.borderColor = ColorConstants.lightGraphite.cgColor
        layer.borderWidth = 2
        frame.size.width += 20
    }
}
