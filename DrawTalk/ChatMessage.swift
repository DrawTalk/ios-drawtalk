//
//  DWTChatMessage.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

enum MessageState: Int {
  // Outbound message states
  case Outgoing
  case Sent
  case Delivered

  // Inbound message states
  case Unread
  case Read
}

class ChatMessage: MessageEvent {
  var text: String
  var clientId: String
  var channel: String?
  
  private(set) var id: String
  private(set) var state: MessageState

  init(text: String, clientId: String, id: String, channel: String?, state: MessageState) {
    self.text = text
    self.clientId = clientId
    self.id = id
    self.channel = channel
    self.state = state
  }
  
  class func outgoing(text: String, channel: String) -> ChatMessage {
    var message = ChatMessage(
      text: text,
      clientId: AppSession.mainSession.currentUser!.userKey!,
      id: NSUUID().UUIDString,
      channel: channel,
      state: .Outgoing)
    
    return message
  }
  
  class func incoming(data: NSData) -> ChatMessage {
    let json = JSON(data: data)
    let clientId = json["clientId"].stringValue
    let id = json["id"].stringValue
    let text = json["message"].stringValue

    var message = ChatMessage(
      text: text,
      clientId: clientId,
      id: id,
      channel: nil,
      state: .Unread)
    
    return message
  }
  
  func payload() -> AnyObject {
    var json = [
      "message": text,
      "clientId": clientId,
      "id": id,
    ]
    
    return json
  }
}