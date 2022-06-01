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

class AsyncQueue: Dispatcher {
    static let main = AsyncQueue(queue: .main)
    static let global = AsyncQueue(queue: .global())
    static let background = AsyncQueue(queue: .global(qos: .background))
}

class SyncQueue: Dispatcher {
    static let main = SyncQueue(queue: .main)
    static let global = SyncQueue(queue: .global())
    static let background = SyncQueue(queue: .global(qos: .background))
}

extension AsyncQueue: Dispatching {
    func dispatch(work: @escaping () -> Void) {
        queue.async(execute: work)
    }
}

extension SyncQueue: Dispatching {
    func dispatch(work: @escaping () -> Void) {
        queue.sync(execute: work)
    }
}
