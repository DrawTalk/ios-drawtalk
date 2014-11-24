//
//  PhoneNumber.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/22/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import CoreData

@objc(PhoneNumber)
class PhoneNumber: NSManagedObject {

    @NSManaged var label: String
    @NSManaged var number: String
    @NSManaged var contact: Contact

}
