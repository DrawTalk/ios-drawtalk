//
//  Message.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/20/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import CoreData
import ObjectiveC

@objc(Message)
class Message: NSManagedObject {

  @NSManaged var date: NSDate
  @NSManaged var identifier: String
  @NSManaged var clientId: String
  @NSManaged var text: String
  @NSManaged var channel: String
  @NSManaged var stateRaw: NSNumber
  @NSManaged var author: Contact
  @NSManaged var chats: NSSet
}

enum MessageState: Int {
  case Unknown

  // Outbound message states
  case Outgoing
  case Sent
  case Delivered

  // Inbound message states
  case Unread
  case Read
}

extension Message {

  var state: MessageState {
    get {
      return MessageState(rawValue: Int(stateRaw))!
    }
    set {
      stateRaw = newValue.rawValue
    }
  }

  func payload() -> AnyObject {
    var json = [
      "message": text,
      "clientId": clientId,
      "id": identifier,
    ]

    return json
  }

  class func outgoing(text: String, channel: String) -> Message {
    var entity: Message!

    CINPersistence.defaultPersistence?.saveAndWait({ (context: CINPersistenceContext!) -> () in
      entity = context.createEntity(Message.self) as Message
      entity.text = text
      entity.date = NSDate()
      entity.clientId = AppSession.mainSession.currentUser!.userKey!
      entity.channel = channel
      entity.identifier = NSUUID().UUIDString
      entity.state = .Outgoing
    })

    return CINPersistence.defaultPersistence?.objectInContext(entity) as Message
  }

  class func incoming(data: NSData) -> Message {
    let json = JSON(data: data)
    let clientId = json["clientId"].stringValue
    let id = json["id"].stringValue
    let text = json["message"].stringValue

    var entity: Message!
    CINPersistence.defaultPersistence?.saveAndWait({ (context: CINPersistenceContext!) -> () in
      entity = context.createEntity(Message.self) as Message
      entity.text = text
      entity.clientId = clientId
      entity.channel = AppSession.mainSession.currentUser!.userKey!
      entity.identifier = id
      entity.state = .Unread
    })

    return CINPersistence.defaultPersistence?.objectInContext(entity) as Message
  }
}