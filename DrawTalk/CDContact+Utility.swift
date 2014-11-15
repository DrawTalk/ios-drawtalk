//
//  CDContact+Utility.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/14/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

extension CDContact {
  class func contact(#recordId: String, context: CINPersistenceContext) -> CDContact {
    var contact: CDContact? = context.findFirstForClass(CDContact.self, attribute: "recordId", withValue: recordId) as? CDContact
    if contact == nil {
      contact = context.createEntity(CDContact.self) as? CDContact
      contact?.recordId = recordId
    }
    return contact!
  }
}