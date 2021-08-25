//
//  Array Queue.swift
//  Safetant WatchKit Extension
//
//  Created by Bryan Khufa on 25/08/21.
//

import Foundation

public protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element)
    mutating func dequeue()
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

public struct QueueArray<T>: Queue {
    private var array: [T] = []
    public init() {}
    
    public var isEmpty: Bool {
        array.isEmpty // 1
    }
    
    public var peek: T? {
        array.first // 2
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() {
        if !isEmpty {
            array.removeFirst()
        }
        return
    }
    
    public func getLength() -> Int {
        return array.count
    }
    
    public func getValues() -> [T] {
        return array
    }
    
    public mutating func resetValues() {
        array.removeAll()
    }
}
