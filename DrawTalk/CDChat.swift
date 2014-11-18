//
//  CDChat.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/15/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import CoreData

@objc(CDChat)
class CDChat: NSManagedObject {

    @NSManaged var contacts: NSSet
    @NSManaged var messages: NSSet

}
