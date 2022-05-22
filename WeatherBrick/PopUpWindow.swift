//
//  PopUpWindow.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 20.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class PopUpWindow: UIView {
    weak var delegate: PopUpWindowDelegate?
    
    var tapGesture = UITapGestureRecognizer()
    
    private lazy var conditionLabels: [UILabel] = []
    
    var isActive = false {
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
        label.font = UIFont(name: AppConstants.Font.ubuntuBold, size: 18)
        label.textColor = AppConstants.Color.graphite
        label.text = "INFO"
        return label
    }()
    
    private lazy var hideButton: UIButton = {
        let tempHideButton = UIButton()
        tempHideButton.layer.borderColor = AppConstants.Color.lightGraphite.cgColor
        tempHideButton.layer.borderWidth = 2
        let fontAttribbute = [
            NSAttributedString.Key.font: UIFont(name: AppConstants.Font.ubuntuMedium, size: 15),
            NSAttributedString.Key.foregroundColor: AppConstants.Color.lightGraphite
        ]
        let buttonTitle = NSAttributedString(
            string: "Hide",
            attributes: fontAttribbute as [NSAttributedString.Key: Any])
        tempHideButton.setAttributedTitle(buttonTitle, for: .normal)
        tempHideButton.layer.cornerRadius = 18
        tempHideButton.addTarget(delegate, action: #selector(delegate?.animateSecond), for: .touchUpInside)
        return tempHideButton
    }()
    
    private lazy var windowBackgroundView: UIView = {
        let tempbackgroundView = UIView()
        tempbackgroundView.layer.cornerRadius = 16
        tempbackgroundView.backgroundColor = AppConstants.Color.darkOrange
        return tempbackgroundView
    }()
    
    private lazy var containerView: UIView = {
        let tempContainerView = UIView()
        tempContainerView.layer.cornerRadius = 16
        tempContainerView.backgroundColor = AppConstants.Color.orange
        return tempContainerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createConditionLabels()

        self.addSubview(windowBackgroundView)
        windowBackgroundView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        conditionLabels.forEach { containerView.addSubview($0) }
        containerView.addSubview(hideButton)
        
        setWindowBackgroundViewConstraints()
        setContainerViewConstraints()
        setTitleLabelConstraints()
        setLabelsConstraints()
        setHideButtonConstraints()
        addTapGestureRecognizer()
        createShadow()
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addTapGestureRecognizer() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(delegateActions))
        self.addGestureRecognizer(tapGesture)
    }
    
    func removeTapGestureRecognizer() {
        self.removeGestureRecognizer(tapGesture)
    }
    
    @objc func delegateActions() {
        if self.isActive {
            delegate?.animateSecond()
        } else {
            delegate?.animateFirst()
        }
    }
    
    func createConditionLabels() {
        let conditions = AppConstants.conditions
        conditions.forEach { condition in
            let label = UILabel()
            label.font = UIFont(name: AppConstants.Font.ubuntuRegular, size: 15)
            label.textColor = AppConstants.Color.graphite
            label.text = condition
            conditionLabels.append(label)
        }
    }
    
    func createShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
    }
    
    @objc func animateIn() {
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
    
    func setWindowBackgroundViewConstraints() {
        windowBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            windowBackgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            windowBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            windowBackgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            windowBackgroundView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    func setContainerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: windowBackgroundView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: windowBackgroundView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: windowBackgroundView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: windowBackgroundView.trailingAnchor, constant: -8)
        ])
    }
    
    func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: windowBackgroundView.centerXAnchor)
        ])
    }
    
    func setLabelsConstraints() {
        var topIndent: CGFloat = 30
        conditionLabels.forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topIndent),
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
                label.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
                label.heightAnchor.constraint(equalToConstant: 20)
            ])
            topIndent += 30
        }
    }
    
    func setHideButtonConstraints() {
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hideButton.widthAnchor.constraint(equalToConstant: 115),
            hideButton.heightAnchor.constraint(equalToConstant: 36),
            hideButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            hideButton.centerXAnchor.constraint(equalTo: windowBackgroundView.centerXAnchor)
        ])
    }
}

@objc protocol PopUpWindowDelegate: AnyObject {
    func animateFirst()
    func animateSecond()
}
