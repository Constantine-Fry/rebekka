//
//  Operation.swift
//  Rebekka
//
//  Created by Constantine Fry on 25/05/15.
//  Copyright (c) 2015 Constantine Fry. All rights reserved.
//

import Foundation

internal enum OperationState {
    case none
    case ready
    case executing
    case finished
}

/** The base class for FTP operations used in framework. */
internal class Operation: Foundation.Operation {
    
    var error: NSError?
    
    internal let configuration: SessionConfiguration
    
    internal var state = OperationState.ready {
        willSet {
            self.willChangeValue(forKey: "isReady")
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        didSet {
            self.didChangeValue(forKey: "isReady")
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isAsynchronous: Bool { get { return true } }
    
    override var isReady: Bool { get { return self.state == .ready } }
    override var isExecuting: Bool { get { return self.state == .executing } }
    override var isFinished: Bool { get { return self.state == .finished } }
    
    init(configuration: SessionConfiguration) {
        self.configuration = configuration
    }
}

