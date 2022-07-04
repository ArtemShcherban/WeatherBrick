//
//  Dispatcher.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 30.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

class Dispatcher {
    var queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
    }
}

protocol Dispatching {
    func dispatch(work: @escaping () -> Void)
}
