//
//  BackgraundImageView.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 24.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

final class BackgraundImageView: UIImageView {
    override init(frame: CGRect = CGRect(
        x: 0,
        y: 0,
        width: UIScreen.main.bounds.size.width,
        height: UIScreen.main.bounds.size.height)) {
            super.init(frame: frame)
            configure()
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        image = UIImage(named: AppConstants.Image.background)
    }
}
