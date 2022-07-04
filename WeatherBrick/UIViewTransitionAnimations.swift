//
//  FadeTransitionExtension.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 14.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
