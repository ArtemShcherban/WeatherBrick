//
//  SyncQueue.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 21.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

final class SyncQueue: Dispatcher {
    static let main = SyncQueue(queue: .main)
    static let global = SyncQueue(queue: .global())
    static let background = SyncQueue(queue: .global(qos: .background))
}

extension SyncQueue: Dispatching {
    func dispatch(work: @escaping () -> Void) {
        queue.sync(execute: work)
    }
}
