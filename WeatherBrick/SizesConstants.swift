//
//  SizesConstants.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 22.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

enum SizesConstants {
    enum Indent {
        static let left: CGFloat = 16.0
        static let right: CGFloat = -16.0
    }
    
    enum Multiplier {
        static let height = 0.08
    }
    
    enum IconSize {
        static let width: CGFloat = 16.0
    }
    
    enum AnimationSize {
        static let width: CGFloat = 200.0
    }
    
    enum DefaultRect {
        static let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
