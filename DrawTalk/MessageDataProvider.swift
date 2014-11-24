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

  // MARK: Fetching

  class func fetchMessages(completion: DataProviderCompletionHandler?) -> [Message]? {
    let Messages = CINPersistence.defaultPersistence?.findAllForClass(Message.self,
      withPredicate: nil,
      sortedBy: nil,
      ascending: false,
      groupBy: nil) as [Message]

    return Messages
  }

}