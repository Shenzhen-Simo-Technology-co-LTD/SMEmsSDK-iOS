//
//  GLMultiDelegate.swift
//  SmartHeater
//
//  Created by GrayLand on 2020/4/7.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

import UIKit

open class GLMultiDelegate<T>: NSObject {
//    fileprivate var delegates = [GLWeak]()
//    private let delegates: NSHashTable<AnyObject> = NSHashTable.init(options: NSPointerFunctions.Options.weakMemory)
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    private let semaphore = DispatchSemaphore.init(value: 1)
    public var isEmpty: Bool {
        return delegates.count == 0
    }
    private func contains(_ delegate: T) -> Bool {
        return delegates.contains(delegate as AnyObject)
    }
    public func add(_ delegate: T) {
        semaphore.wait()
        guard !self.contains(delegate) else {
            return
        }
        delegates.add(delegate as AnyObject)
        semaphore.signal()
    }
    public func remove(_ delegate: T) {
        semaphore.wait()
        delegates.remove(delegate as AnyObject)
        semaphore.signal()
    }
    public func removeAll() {
        semaphore.wait()
        delegates.removeAllObjects()
        semaphore.signal()
    }
    public func invoke(_ invocation: @escaping (T) -> ()) {
        semaphore.wait()
        for d in delegates.allObjects {
            invocation( d as! T)
        }
        semaphore.signal()
    }
    public func invokeInMainAsync(_ invocation: @escaping (T) -> ()) {
        DispatchQueue.main.async {
            self.semaphore.wait()
            for d in self.delegates.allObjects {
                invocation( d as! T)
            }
            self.semaphore.signal()
        }
    }
}

