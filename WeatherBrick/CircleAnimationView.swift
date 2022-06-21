//
//  CircleAnimation.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 19.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import Lottie

final class CircleAnimationView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var animationSubview: AnimationView = {
        var animation = AnimationView()
        animation = .init(name: "circularAnimationBlue")
        animation.loopMode = .loop
        animation.backgroundColor = .clear
        animation.animationSpeed = 1.0
        return animation
    }()
    
    private func configure() {
        frame.size.height = 5
        frame.size.width = 5
        backgroundColor = .clear
    }
    
    func start() {
        fadeTransition(0.2)
        addSubview(animationSubview)
        setSubviewConstraints()
        animationSubview.play()
    }
    
    func stop() {
        fadeTransition(0.2)
        animationSubview.stop()
        animationSubview.removeFromSuperview()
    }
    
    private func setSubviewConstraints() {
        animationSubview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationSubview.topAnchor.constraint(equalTo: self.topAnchor),
            animationSubview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            animationSubview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            animationSubview.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
