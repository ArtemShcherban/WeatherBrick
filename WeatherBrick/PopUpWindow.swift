//
//  PopUpWindow.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 20.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import DeviceKit

final class PopUpWindow: UIView {
    weak var delegate: PopUpWindowDelegate?
    
    private lazy var tapGesture = UITapGestureRecognizer()
    private lazy var conditionLabels: [UILabel] = []
    
    lazy var isActive = false {
        didSet {
            if isActive {
                removeTapGestureRecognizer()
            } else {
                addTapGestureRecognizer()
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppConstants.Font.ubuntuBold, size: AppConstants.bigScreenSize ? 18 : 16)
        label.textColor = AppConstants.Color.graphite
        label.text = AppConstants.TitleFor.popUpWindow
        return label
    }()
    
    private lazy var hideButton: UIButton = {
        let tempHideButton = UIButton()
        tempHideButton.layer.borderColor = AppConstants.Color.lightGraphite.cgColor
        tempHideButton.layer.borderWidth = AppConstants.bigScreenSize ? 2 : 1
        let fontAttribbute = [
            NSAttributedString.Key.font: UIFont(
                name: AppConstants.Font.ubuntuMedium,
                size: AppConstants.bigScreenSize ? 15 : 14),
            NSAttributedString.Key.foregroundColor: AppConstants.Color.lightGraphite
        ]
        let buttonTitle = NSAttributedString(
            string: AppConstants.TitleFor.hideButton,
            attributes: fontAttribbute as [NSAttributedString.Key: Any])
        tempHideButton.setAttributedTitle(buttonTitle, for: .normal)
        tempHideButton.layer.cornerRadius = AppConstants.bigScreenSize ? 18 : 14
        tempHideButton.addTarget(self, action: #selector(delegateActions), for: .touchUpInside)
        return tempHideButton
    }()
    
    private lazy var windowBackgroundView: UIView = {
        let tempbackgroundView = UIView()
        tempbackgroundView.layer.cornerRadius = 16
        tempbackgroundView.backgroundColor = AppConstants.Color.brightOrange
        return tempbackgroundView
    }()
    
    private lazy var containerView: UIView = {
        let tempContainerView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: (UIScreen.main.bounds.width * 0.7 - 8),
            height: UIScreen.main.bounds.height * 0.45))
        tempContainerView.layer.cornerRadius = 16
        tempContainerView.clipsToBounds = true
        tempContainerView.backgroundColor = AppConstants.Color.orange
        return tempContainerView
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let tempGradientLayer = CAGradientLayer()
        tempGradientLayer.colors = [AppConstants.Color.orange.cgColor, AppConstants.Color.brightOrange.cgColor]
        tempGradientLayer.locations = [0, 0.9]
        tempGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        tempGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        tempGradientLayer.frame = containerView.bounds
        return tempGradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createConditionLabels()
        addSubviews()
        setConstraints()
        addTapGestureRecognizer()
        createShadow()
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviews() {
        addSubview(windowBackgroundView)
        windowBackgroundView.addSubview(containerView)
        containerView.layer.addSublayer(gradientLayer)
        containerView.addSubview(titleLabel)
        conditionLabels.forEach { containerView.addSubview($0) }
        containerView.addSubview(hideButton)
    }
    
    private func setConstraints() {
        setWindowBackgroundViewConstraints()
        setContainerViewConstraints()
        setTitleLabelConstraints()
        setLabelsConstraints()
        setHideButtonConstraints()
    }
    
    private func addTapGestureRecognizer() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(delegateActions))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func removeTapGestureRecognizer() {
        self.removeGestureRecognizer(tapGesture)
    }
    
    @objc private func delegateActions() {
        if self.isActive {
            delegate?.popWindowOut()
        } else {
            delegate?.popWindowIn()
        }
    }
    
    private func createConditionLabels() {
        let conditions = AppConstants.conditions
        conditions.forEach { condition in
            let label = UILabel()
            label.font = UIFont(
                name: AppConstants.Font.ubuntuRegular,
                size: AppConstants.bigScreenSize ? 15 : 13)
            label.textColor = AppConstants.Color.graphite
            label.text = condition
            conditionLabels.append(label)
        }
    }
    
   func createShadow() {
        //        layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
//                layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //        layer.shouldRasterize = true
        //        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func applyGradientAnimation() {
        createGradientAnimation(layer: gradientLayer)
    }
    
    private func createGradientAnimation(layer: CAGradientLayer) {
        let gradientMotion = CABasicAnimation(keyPath: "locations")
        gradientMotion.fromValue = layer.locations
        gradientMotion.duration = 1
        if isActive == false {
            gradientMotion.toValue = layer.locations = [1, 1.9]
            layer.add(gradientMotion, forKey: nil)
        } else if isActive == true {
            gradientMotion.toValue = layer.locations = [0, 0.9]
            layer.add(gradientMotion, forKey: nil)
        }
    }
    
    @objc private func animateIn() {
        self.windowBackgroundView.transform = CGAffineTransform(translationX: 0, y: 500)
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseIn) {
                self.windowBackgroundView.transform = .identity
        }
    }
    
    private func setWindowBackgroundViewConstraints() {
        windowBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            windowBackgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            windowBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            windowBackgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            windowBackgroundView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    private func setContainerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: windowBackgroundView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: windowBackgroundView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: windowBackgroundView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: windowBackgroundView.trailingAnchor, constant: -8)
        ])
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: containerView.frame.height * 0.08),
            titleLabel.centerXAnchor.constraint(equalTo: windowBackgroundView.centerXAnchor)
        ])
    }
    
    private func setLabelsConstraints() {
        var topIndent: CGFloat = containerView.frame.height * 0.08
        conditionLabels.forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topIndent),
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
                label.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
                label.heightAnchor.constraint(equalToConstant: containerView.frame.height * 0.05)
            ])
            topIndent += containerView.frame.height * 0.08
        }
    }
    
    private func setHideButtonConstraints() {
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hideButton.widthAnchor.constraint(equalToConstant: AppConstants.bigScreenSize ? 115 : 87),
            hideButton.heightAnchor.constraint(equalToConstant: AppConstants.bigScreenSize ? 36 : 28),
            hideButton.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: containerView.frame.height * -0.08),
            hideButton.centerXAnchor.constraint(equalTo: windowBackgroundView.centerXAnchor)
        ])
    }
}

protocol PopUpWindowDelegate: AnyObject {
    func popWindowIn()
    func popWindowOut()
}
