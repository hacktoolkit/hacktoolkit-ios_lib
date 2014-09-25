//
//  DataStructures.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

struct Stack<T> {
    var items = [T]()
    
    mutating func push(item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    func peek() -> T? {
        return items.last
    }
}

struct Queue<T> {
    var items = [T]()
    
    mutating func enqueue(item: T) {
        items.append(item)
    }
    
    mutating func dequeue() -> T {
        return items.removeAtIndex(0)
    }
}
