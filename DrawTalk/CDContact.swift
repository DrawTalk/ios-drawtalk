//
//  CDContact.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/14/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import CoreData

@objc(CDContact)
class CDContact: NSManagedObject {

    @NSManaged var token: String
    @NSManaged var recordId: String

}
