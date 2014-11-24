//
//  ChatDataProvider.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/22/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

class ChatDataProvider: DataProvider {
  
  class func fetchAllChats() -> [Chat]? {
    let cdChats = CINPersistence.defaultPersistence?.findAllForClass(Chat.self,
      withPredicate: nil,
      sortedBy: nil,
      ascending: false,
      groupBy: nil) as [Chat]

    return nil
  }
  
}