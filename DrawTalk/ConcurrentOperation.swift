//
//  ConcurrentOperation.swift
//
//  Created by Caleb Davenport on 7/7/14.
//
//  Learn more at http://blog.calebd.me/swift-concurrent-operations
//

import Foundation

protocol OperationResult {}

class ConcurrentOperation: NSOperation {
  
  // MARK: - Types
  
  enum State {
    case Ready, Executing, Finished
    func keyPath() -> String {
      switch self {
      case Ready:
        return "isReady"
      case Executing:
        return "isExecuting"
      case Finished:
        return "isFinished"
      }
    }
  }
  
  // MARK: - Properties
  
  var state: State {
    willSet {
      willChangeValueForKey(newValue.keyPath())
      willChangeValueForKey(state.keyPath())
    }
    didSet {
      didChangeValueForKey(oldValue.keyPath())
      didChangeValueForKey(state.keyPath())
    }
  }
  
  // MARK: - Initializers
  
  override init() {
    state = State.Ready
    super.init()
  }

  // MARK: - NSOperation
  
  override var ready: Bool {
    return super.ready && state == .Ready
  }
  
  override var executing: Bool {
    return state == .Executing
  }
  
  override var finished: Bool {
    return state == .Finished
  }
  
  override var asynchronous: Bool {
    return true
  }
}