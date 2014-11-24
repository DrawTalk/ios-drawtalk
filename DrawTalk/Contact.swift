//
//  CDContact.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/22/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import CoreData

@objc(Contact)
class Contact: NSManagedObject {
  
  @NSManaged var channel: String?
  @NSManaged var recordId: String
  @NSManaged var image: NSData?
  @NSManaged var lastName: String?
  @NSManaged var firstName: String?
  @NSManaged var chats: NSSet
  @NSManaged var phoneNumbers: NSSet
  
}