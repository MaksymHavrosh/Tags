//
//  NetworkActivityIndicatorManager.swift
//  Tags
//
//  Created by MG on 14.07.2021.
//

import UIKit

final class NetworkActivityIndicatorManager {
    
    private var taskCount: Int
    private let taskCountSyncQueue = DispatchQueue(label: "com.project.taskCountSyncQueue")
    
    static let shared = NetworkActivityIndicatorManager()
    
    private init() {
        taskCount = 0
    }
    
    func start() {
        taskCountSyncQueue.sync {
            taskCount += 1
        }
    }
    
    func stop() {
        taskCountSyncQueue.sync {
            if self.taskCount > 0 {
                self.taskCount -= 1
            }
        }
    }
}
