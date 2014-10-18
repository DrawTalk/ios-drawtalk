//
//  EventBus.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

@objc
public protocol MessageEvent {
   func toPayload() -> AnyObject
}

public typealias EventBusHandler = (MessageEvent) -> Void
public typealias Observer = NSObjectProtocol

public let kMessageEventOutgoing = "kMessageEventOutgoing"
public let kMessageEventIncoming = "kMessageEventIncoming"

public class MessageEventBus {
  
  private var observers: [Observer] = []
  
  class var defaultBus: MessageEventBus {
  struct Static {
    static let instance = MessageEventBus()
    }
    return Static.instance
  }

  public func post(name: String, event: MessageEvent!) {
    NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil, userInfo: ["event" : event])
  }
  
  public func subscribe(name: String, handler: EventBusHandler!) -> Observer {
    let observer = NSNotificationCenter.defaultCenter().addObserverForName(
      name,
      object: nil,
      queue: nil,
      usingBlock: { (note: NSNotification!) -> Void in
        if let userInfo = note.userInfo {
          if let event: AnyObject = userInfo["event"] {
            if event is MessageEvent {
              handler(event as MessageEvent)
            }
          }
        }
      })
    
    observers.append(observer)
    
    return observer
  }
  
  public func unsubscribe(observer: Observer) {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
  public func unsubscribeAll() {
    for observer in observers {
      unsubscribe(observer)
    }
    observers.removeAll(keepCapacity: false)
  }
}
