//
//  Stack.swift
//  pep9pad
//
//  Created by Josh Haug on 2/28/17.
//  Copyright © 2017 Pepperdine University. All rights reserved.
//


import Foundation

struct Stack<T> {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T! {
        return (items.count > 0 ? items.removeLast() : nil)
    }
    
    mutating func popAndDispose() {
        if(items.count > 0) {
            items.removeLast()
        }
    }
    
    func peek() -> T! {
        return items.last
    }
    
    func height() -> Int {
        return items.count
    }
    
    func isEmpty() -> Bool {
        return items.count == 0
    }
}
