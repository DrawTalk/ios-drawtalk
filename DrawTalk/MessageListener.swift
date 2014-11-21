//
//  PersistenceListener.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/20/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

class MessageListener {
  
  class var defaultListener: MessageListener {
    struct Static {
      static let instance = MessageListener()
    }
    return Static.instance
  }
  
  func observe() {
    MessageEventBus.defaultBus.subscribe(.Incoming, handler: { (event: MessageEvent) -> Void in
      let chatMessage = event as ChatMessage
      self.saveMessage(chatMessage)
    })
    
    MessageEventBus.defaultBus.subscribe(.Outgoing, handler: { (event: MessageEvent) -> Void in
      let chatMessage = event as ChatMessage
      self.saveMessage(chatMessage)
    })
  }
  
  private func saveMessage(message: ChatMessage) {
    MessageDataProvider.saveMessage(message, completion: nil)
  }
}