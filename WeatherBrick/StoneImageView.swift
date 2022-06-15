//
//  StoneImageView.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 09.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import DeviceKit

final class StoneImageView: UIImageView {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        guard let stoneImage = UIImage(named: AppConstants.StoneImage.normal),
        let risizaedImage = stoneImage.resized(toWidth: UIScreen.main.bounds.height * 0.27) else { return }
        bounds.size = risizaedImage.size
        image = risizaedImage
        alpha = 1
        center.x = UIScreen.main.bounds.width / 2
        center.y = risizaedImage.size.height / 2 - (AppConstants.bigScreenSize ? 0 : 12)
        isUserInteractionEnabled = true
        setAnchorPoint(CGPoint(x: 0.5, y: 0.0))
    }
    
    func swipeAnimation() {
        transform = CGAffineTransform(translationX: 0.0, y: 30)
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.0,
            options: .curveEaseIn) {
                self.transform = .identity
        }
    }
    
    func windAnimation() {
        transform = CGAffineTransform(rotationAngle: -.pi / 8)
        UIView.animateKeyframes(
            withDuration: 3.0,
            delay: 0.0,
            options: [
                UIView.KeyframeAnimationOptions.repeat,
                UIView.KeyframeAnimationOptions.allowUserInteraction,
                UIView.KeyframeAnimationOptions.autoreverse
            ],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                    self.transform = CGAffineTransform(rotationAngle: .pi / 8)
                }
            },
            completion: nil)
    }
}

extension StoneImageView {
    func setAnchorPoint(_ point: CGPoint) {
        let newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        let oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
