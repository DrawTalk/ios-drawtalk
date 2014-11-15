
//
//  DWTContactABRecord.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/25/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import AddressBook

let kDWTContactABRecordIndentifier = "ContactABRecordIndentifier"
let kDWTContactABRecordFirstNameProperty = "ContactABRecordFirstNameProperty"
let kDWTContactABRecordLastNameProperty = "ContactABRecordLastNameProperty"
let kDWTContactABRecordImageData = "ContactABRecordImageData"
let kDWTContactABRecordEmails = "ContactABRecordEmails"
let kDWTContactABRecordPhoneNumbers = "ContactABRecordPhoneNumbers"
let kDWTContactABRecordPhoneLabel = "ContactABRecordPhoneLabel"
let kDWTContactABRecordPhoneNumber = "ContactABRecordPhoneNumber"

class ContactABRecord {
  
  private var abRecord: ABRecord!
  private var result: [String : AnyObject] = [String : AnyObject]()
  
  init(abRecord: ABRecord) {
    self.abRecord = abRecord
    
    parseIdentifier()
    parseName()
    //parseImage()
    parseEmails()
    parsePhoneNumbers()
  }

  private func parseIdentifier() {
    let recordId: ABRecordID = ABRecordGetRecordID(abRecord);
    result[kDWTContactABRecordIndentifier] = String(recordId)
  }
  
  private func parseImage() {
    let imgData = ABPersonCopyImageDataWithFormat(abRecord, kABPersonImageFormatOriginalSize).takeRetainedValue()
    let data = imgData as NSData
    if data.length > 0 {
      result[kDWTContactABRecordImageData] = data
    }
  }
  
  private func parseName() {
    var unmanagedName = ABRecordCopyValue(abRecord, kABPersonFirstNameProperty)
    let firstName: String = Unmanaged.fromOpaque(unmanagedName.toOpaque()).takeUnretainedValue() as NSObject as String
    
    var unmanagedLastName = ABRecordCopyValue(abRecord, kABPersonLastNameProperty)
    let lastName: String = Unmanaged.fromOpaque(unmanagedLastName.toOpaque()).takeUnretainedValue() as NSObject as String
    
    result[kDWTContactABRecordFirstNameProperty] = firstName
    result[kDWTContactABRecordLastNameProperty] = lastName
  }
  
  private func parseEmails() {
    var unmanagedEmails = ABRecordCopyValue(abRecord, kABPersonEmailProperty)
    let emails: ABMultiValueRef = Unmanaged.fromOpaque(unmanagedEmails.toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    
    let count = ABMultiValueGetCount(emails)
    
    var list: [String] = []
    
    for index in 0..<count{
      let unmanagedEmail = ABMultiValueCopyValueAtIndex(emails, index)
      let email: String = Unmanaged.fromOpaque(unmanagedEmail.toOpaque()).takeUnretainedValue() as NSObject as String
      list.append(email)
    }
    
    if count > 0 {
      result[kDWTContactABRecordEmails] = list
    }
  }
  
  private func parsePhoneNumbers() {
    var unmanagedPhones = ABRecordCopyValue(abRecord, kABPersonPhoneProperty)
    let phones: ABMultiValueRef = Unmanaged.fromOpaque(unmanagedPhones.toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    
    let count = ABMultiValueGetCount(phones)
    
    var list: [[String : AnyObject]] = []
    
    for index in 0..<count{
      let unmanagedPhoneLabel = ABMultiValueCopyLabelAtIndex(phones, index)
      let phoneLabel: String = Unmanaged.fromOpaque(unmanagedPhoneLabel.toOpaque()).takeUnretainedValue() as NSObject as String
      
      let unmanagedPhoneNumber = ABMultiValueCopyValueAtIndex(phones, index)
      let phoneNumber: String = Unmanaged.fromOpaque(unmanagedPhoneNumber.toOpaque()).takeUnretainedValue() as NSObject as String
      
      list.append([
        kDWTContactABRecordPhoneLabel: phoneLabel,
        kDWTContactABRecordPhoneNumber: phoneNumber
        ])
    }
    
    if count > 0 {
      result[kDWTContactABRecordPhoneNumbers] = list
    }
  }
  
}

extension ContactABRecord {
  
  func toContact() -> Contact {
    var contact = Contact()
    
    contact.identifier = result[kDWTContactABRecordIndentifier] as AnyObject? as? String
    contact.firstName = result[kDWTContactABRecordFirstNameProperty] as AnyObject? as? String
    contact.lastName = result[kDWTContactABRecordLastNameProperty] as AnyObject? as? String
    contact.imageData = result[kDWTContactABRecordImageData] as AnyObject? as? NSData
    contact.emails = result[kDWTContactABRecordEmails] as AnyObject? as? [String]
    
    let phones = result[kDWTContactABRecordPhoneNumbers] as AnyObject? as? [[String : AnyObject]]
    contact.phoneNumbers = phones?.map({ (phone: [String : AnyObject]) -> PhoneNumber in
      return PhoneNumber(
        label: phone[kDWTContactABRecordPhoneLabel] as AnyObject? as String,
        number: phone[kDWTContactABRecordPhoneNumber] as AnyObject? as String
      )
    })
    
    return contact
  }
}