//
//  DWTContact.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/25/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

struct PhoneNumber {
  var label: String
  var number: String
}

class Contact {
  
  var identifier: String!
  var firstName: String?
  var lastName: String?
  var imageData: NSData?
  var emails: [String]?
  var phoneNumbers: [PhoneNumber]?
  
  var token: String?

  init() {
    
  }
}
