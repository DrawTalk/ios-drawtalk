//
//  CDMessage.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/20/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import CoreData

@objc(CDMessage)
class CDMessage: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var drawing: String
    @NSManaged var identifier: String
    @NSManaged var stateRaw: NSNumber
    @NSManaged var author: CDContact
    @NSManaged var chats: NSSet

}
