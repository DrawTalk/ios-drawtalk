//
//  MessageDataProvider.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/20/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

class MessageDataProvider: DataProvider {
  
  // MARK: Public
  
  // MARK: Saving
  
  class func saveMessage(message: ChatMessage, completion: DataProviderCompletionHandler?) {
    CINPersistence.defaultPersistence?.save({ (context: CINPersistenceContext!) -> () in
      var entity: CDMessage? = context.findFirstForClass(CDMessage.self, attribute: "identifier", withValue: message.id) as? CDMessage
      if entity == nil {
        entity = context.createEntity(CDMessage.self) as? CDMessage
        entity!.identifier = message.id
        entity!.stateRaw = message.state.rawValue
      }
      }, completion:({ (success, error) in
        completion?(success, error)
        noop()
      }))
  }
  
  // MARK: Fetching
  
  class func fetchMessages(completion: DataProviderCompletionHandler?) -> [ChatMessage]? {
    let cdMessages = CINPersistence.defaultPersistence?.findAllForClass(CDMessage.self,
      withPredicate: nil,
      sortedBy: nil,
      ascending: false,
      groupBy: nil) as [CDMessage]
    
    var messages: [ChatMessage] = cdMessages.map { cdMessage in
      var item = ChatMessage(
        text: "",
        clientId: cdMessage.author.channel,
        id: cdMessage.identifier,
        channel: nil,
        state: MessageState(rawValue: Int(cdMessage.stateRaw))!)
      
      return item
    }
    
    return messages
  }
  
}