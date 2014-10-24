//
//  DWTAddressBookImport.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import AddressBook

typealias DWTAddressBookImportCompletionHandler = ([AnyObject]?, NSError?) -> Void

class DWTAddressBookImport {
  
  private lazy var importQueue: dispatch_queue_t = {
    let queue: dispatch_queue_t = dispatch_queue_create("com.drawtalk.import.queue", DISPATCH_QUEUE_SERIAL);
    return queue
  }()
  
  class var defaultAddressBookImport: DWTAddressBookImport {
  struct Static {
    static let instance = DWTAddressBookImport()
    }
    return Static.instance
  }
  
  func contacts(completion: DWTAddressBookImportCompletionHandler!) {
    let status = ABAddressBookGetAuthorizationStatus()
    
    // Creates an address book reference in the dedicated `importQueue`.
    // From Apple's doc: "You must ensure that an instance of ABAddressBookRef is used by only one thread."
    let AddressBookRefCreateWithCompletion = {
      (handler: ((ABAddressBookRef) -> Void)!) -> Void in
      let instance = DWTAddressBookImport.defaultAddressBookImport
      dispatch_async(instance.importQueue, { () -> Void in
        var error : Unmanaged<CFError>? = nil
        let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        if adbk == nil {
          //let err: NSError = CFBridgingRelease(error);
          //completion(nil, error)
        } else {
          handler(adbk!)
        }
      })
    }
    
    switch status {
    case .Denied, .Restricted:
      println("no access")
    case .Authorized, .NotDetermined:
      AddressBookRefCreateWithCompletion { (ref: ABAddressBookRef) in
        ABAddressBookRequestAccessWithCompletion(ref) {
          (granted:Bool, err:CFError!) in
          if granted {
            // retrieve contacts
            let people = ABAddressBookCopyArrayOfAllPeople(ref).takeRetainedValue() as NSArray as [ABRecord]
            for person in people {
              //println(ABRecordCopyCompositeName(person).takeRetainedValue())
              let contact = Contact(abRecord: person)
              contact.toContact()
            }
          } else {
            println(err)
          }
        }
      }
    }
  }
}

class Contact {
  private var abRecord: ABRecord!
  
  init(abRecord: ABRecord) {
    self.abRecord = abRecord
  }
  
  func toContact() {
    let recordId: ABRecordID = ABRecordGetRecordID(abRecord);
    name()
    image()
    emails()
    phoneNumbers()
  }
  
  private func image() {
    let imgData = ABPersonCopyImageDataWithFormat(abRecord, kABPersonImageFormatOriginalSize).takeRetainedValue()
    let data = imgData as NSData
    println(data.length)
  }
  
  private func name() {
    var unmanagedName = ABRecordCopyValue(abRecord, kABPersonFirstNameProperty)
    let name: String = Unmanaged.fromOpaque(unmanagedName.toOpaque()).takeUnretainedValue() as NSObject as String
    println(name)
    
    var unmanagedLastName = ABRecordCopyValue(abRecord, kABPersonLastNameProperty)
    let lastName: String = Unmanaged.fromOpaque(unmanagedLastName.toOpaque()).takeUnretainedValue() as NSObject as String
    println(lastName)
  }
  
  private func emails() {
    var unmanagedEmails = ABRecordCopyValue(abRecord, kABPersonEmailProperty)
    let emails: ABMultiValueRef = Unmanaged.fromOpaque(unmanagedEmails.toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    
    let count = ABMultiValueGetCount(emails)
    
    for index in 0..<count{
      let unmanagedEmail = ABMultiValueCopyValueAtIndex(emails, index)
      let email: String = Unmanaged.fromOpaque(unmanagedEmail.toOpaque()).takeUnretainedValue() as NSObject as String
      println(email)
    }
  }
  
  private func phoneNumbers() {
    var unmanagedPhones = ABRecordCopyValue(abRecord, kABPersonPhoneProperty)
    let phones: ABMultiValueRef = Unmanaged.fromOpaque(unmanagedPhones.toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    
    let count = ABMultiValueGetCount(phones)
    
    for index in 0..<count{
      let unmanagedPhoneLabel = ABMultiValueCopyLabelAtIndex(phones, index)
      let phoneLabel: String = Unmanaged.fromOpaque(unmanagedPhoneLabel.toOpaque()).takeUnretainedValue() as NSObject as String
      
      let unmanagedPhoneNumber = ABMultiValueCopyValueAtIndex(phones, index)
      let phoneNumber: String = Unmanaged.fromOpaque(unmanagedPhoneNumber.toOpaque()).takeUnretainedValue() as NSObject as String

      println(phoneLabel)
      println(phoneNumber)
    }
  }

}