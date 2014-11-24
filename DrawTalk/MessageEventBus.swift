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
  func payload() -> AnyObject
  var channel: String { get }
}

typealias EventBusHandler = (Message) -> Void
typealias Observer = NSObjectProtocol

enum MessageEventType: String {
  case Outgoing = "kMessageEventOutgoing"
  case Incoming = "kMessageEventIncoming"
}

private let kEvent = "event"

class MessageEventBus {

  private var observers: [Observer] = []

  class var defaultBus: MessageEventBus {
  struct Static {
    static let instance = MessageEventBus()
    }
    return Static.instance
  }

  func post(type: MessageEventType, message: Message) {
    NSNotificationCenter.defaultCenter().postNotificationName(type.rawValue, object: nil, userInfo: [kEvent : message])
  }

  func subscribe(type: MessageEventType, handler: EventBusHandler!) -> Observer {
    let observer = NSNotificationCenter.defaultCenter().addObserverForName(
      type.rawValue,
      object: nil,
      queue: nil,
      usingBlock: { (note: NSNotification!) -> Void in
        if let userInfo = note.userInfo {
          if let event: AnyObject = userInfo[kEvent] {
            if event is Message {
              handler(event as Message)
            }
          }
        }
      })

    observers.append(observer)

    return observer
  }

  func unsubscribe(observer: Observer) {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }

  func unsubscribeAll() {
    for observer in observers {
      unsubscribe(observer)
    }
    observers.removeAll(keepCapacity: false)
  }
}
