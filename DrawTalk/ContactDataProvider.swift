//
//  ContactDataProvider.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/20/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

class ContactDataProvider: DataProvider {

  // MARK: Public
  
  // MARK: Saving

  // MARK: Fetching
  
  class func fetchAllCDContacts() -> [Contact] {
    return CINPersistence.defaultPersistence?.findAllForClass(Contact.self,
      withPredicate: nil,
      sortedBy: nil,
      ascending: false,
      groupBy: nil) as [Contact]
  }
  
  // MARK: Private
  
}