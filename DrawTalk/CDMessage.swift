//
//  CDMessage.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/15/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import CoreData

@objc(CDMessage)
class CDMessage: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var drawing: NSString
    @NSManaged var chats: String
    @NSManaged var author: CDContact

}
