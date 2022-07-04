//
//  WeatherMainViewAnimationExtension.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 19.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

extension WeatherMainView {
    func animatePopUpWindowIn() {
        self.axisYConstraint.constant = 0
        UIView.animate(
            withDuration: 1.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut) {
                for index in 1..<self.subviews.count - 1 {
                    self.alphaValues.append(self.subviews[index].alpha)
                    self.subviews[index].alpha = 0
                }
                self.popUpWindow.applyGradientAnimation()
                self.popUpWindow.isActive = true
                self.layoutIfNeeded()
        }
    }
    
    func animatePopUpWindowOut() {
        self.axisYConstraint.constant = UIScreen.main.bounds.height * 0.64
        UIView.animate(
            withDuration: 1.2,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut) {
                for index in 1..<self.subviews.count - 1 {
                    self.subviews[index].alpha = self.alphaValues[index - 1]
                }
                self.alphaValues = []
                self.popUpWindow.applyGradientAnimation()
                self.popUpWindow.isActive = false
                self.layoutIfNeeded()
        }
    }
}
