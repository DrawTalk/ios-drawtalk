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
  
  class func saveContact(contact: Contact, completion: DataProviderCompletionHandler?) {
    CINPersistence.defaultPersistence?.save({ (context: CINPersistenceContext!) -> () in
        self.saveContact(contact, context: context)
      }, completion:({ (success, error) in
        completion?(success, error)
        noop()
    }))
  }

  class func saveContacts(contacts: [Contact], completion: DataProviderCompletionHandler?) {
    CINPersistence.defaultPersistence?.save({ (context: CINPersistenceContext!) -> () in
      for contact in contacts {
        self.saveContact(contact, context: context)
      }
      }, completion:({ (success, error) in
        completion?(success, error)
        noop()
      }))
  }
  
  // MARK: Fetching
  
  class func fetchAllCDContacts() -> [CDContact] {
    return CINPersistence.defaultPersistence?.findAllForClass(CDContact.self,
      withPredicate: nil,
      sortedBy: nil,
      ascending: false,
      groupBy: nil) as [CDContact]
  }
  
  // MARK: Private
  
  private class func saveContact(contact: Contact, context: CINPersistenceContext) {
    var entity: CDContact? = context.findFirstForClass(
      CDContact.self,
      attribute: "recordId",
      withValue: contact.identifier) as? CDContact
    
    if entity == nil {
      entity = context.createEntity(CDContact.self) as? CDContact
      entity?.recordId = contact.identifier
      entity?.channel = contact.channel!
      entity?.recordId = contact.identifier
    }
  }
  
}