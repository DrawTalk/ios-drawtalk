//
//  DWTAddressBookImport.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import AddressBook

typealias AddressBookImportCompletionHandler = ([Contact]?, NSError?) -> Void

class AddressBookImport {
  
  private var importQueue: dispatch_queue_t
  
  class var defaultAddressBookImport: AddressBookImport {
  struct Static {
    static let instance = AddressBookImport()
    }
    return Static.instance
  }
  
  init() {
    importQueue = dispatch_queue_create("com.drawtalk.import.queue", DISPATCH_QUEUE_SERIAL);
  }
  
  func contacts(completion: AddressBookImportCompletionHandler!) {
    let status = ABAddressBookGetAuthorizationStatus()
    
    // Creates an address book reference in the dedicated `importQueue`.
    // From Apple's doc: "You must ensures that an instance of ABAddressBookRef is used by only one thread."
    let AddressBookRefCreateWithCompletion = {
      (handler: ((ABAddressBookRef) -> Void)!) -> Void in
      let instance = AddressBookImport.defaultAddressBookImport
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
            var contacts: [Contact] = []
            // retrieve contacts
            let people = ABAddressBookCopyArrayOfAllPeople(ref).takeRetainedValue() as NSArray as [ABRecord]
            for person in people {
              let contact = ContactABRecord(abRecord: person)
              contacts.append(contact.toContact())
            }
            completion(contacts, nil)
          } else {
            println(err)
          }
        }
      }
    }
  }
}