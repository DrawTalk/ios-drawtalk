//
//  DWTChatMessage.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

public enum MessageState {
  case OUTGOING
  case INCOMING
}

public class ChatMessage: MessageEvent {
  var text: String
  var clientId: String
  
  private var id: String
  private var channel: String
  private var state: MessageState
  
  init(text: String, clientId: String, id: String, channel: String, state: MessageState) {
    self.text = text
    self.clientId = clientId
    self.id = id
    self.channel = channel
    self.state = state
  }
  
  public class func outgoing(payload: String) -> ChatMessage {
    var message = ChatMessage(
      text: payload,
      clientId: UIDevice.currentDevice().identifierForVendor.UUIDString,
      id: NSUUID().UUIDString,
      channel: "hello/world",
      state: MessageState.OUTGOING)
    
    return message
  }
  
  public class func incoming(data: NSData) -> ChatMessage {
    let json = JSON(data: data)
    let clientId = json["clientId"].stringValue
    let id = json["id"].stringValue
    let text = json["message"].stringValue
    
    var message = ChatMessage(
      text: text,
      clientId: clientId,
      id: id,
      channel: "hello/world",
      state: MessageState.INCOMING)
    
    return message
  }
  
  public func toPayload() -> AnyObject {
    var json = [
      "message": text,
      "clientId": clientId,
      "id": id,
    ]
    
    return json
  }
}