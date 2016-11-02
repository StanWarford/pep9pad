//
//  GCDUtilities.swift
//  pep9pad
//
//  Created by Josh Haug on 11/2/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//


import Foundation
import Dispatch

/// The serial queue on which all UI events are performed. All processes placed in this thread are guaranteed to be executed.
var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

/// The `GlobalUserInteractiveQueue` is for tasks that need to be done immediately to keep the UI looking good. Use it for UI updates, event handling and small workloads that require low latency. Don't put too much on this queue.
var GlobalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
}

/// The `GlobalUserInitiatedQueue` is for tasks that were initiated from the UI and can be performed asynchronously. It should be used when the user is waiting for immediate results, and for tasks required to continue user interaction.
var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
}

/// The `GlobalUtilityQueue` is reserved for long-running tasks, typically with a user-visible progress indicator. Use it for computations, I/O, networking, continous data feeds and similar tasks. This class is designed to be energy efficient.
var GlobalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
}

/// The `GlobalBackgroundQueue` is for tasks that are essentially invisible to the user. Use it for prefetching, maintenance, and other tasks that don’t require user interaction and aren't time-sensitive.
var GlobalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
}


func delay(delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
