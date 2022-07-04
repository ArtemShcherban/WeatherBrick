//
//  AsyncQueue.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 21.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

final class AsyncQueue: Dispatcher {
    static let main = AsyncQueue(queue: .main)
    static let global = AsyncQueue(queue: .global())
    static let background = AsyncQueue(queue: .global(qos: .background))
}

extension AsyncQueue: Dispatching {
    func dispatch(work: @escaping () -> Void) {
        queue.async(execute: work)
    }
}
