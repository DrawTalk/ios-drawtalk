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
            // retrieve contacts
            let people = ABAddressBookCopyArrayOfAllPeople(ref).takeRetainedValue() as NSArray as [ABRecord]
            
            var contacts = [Contact]()
            CINPersistence.defaultPersistence?.save({ (context: CINPersistenceContext!) -> () in
              
              for person in people {
                
                let contact = ContactABRecord(abRecord: person)
                var record = contact.record
                
                var contactEntity = context.createEntity(Contact.self) as Contact
                contactEntity.recordId = (record[kDWTContactABRecordIndentifier] as AnyObject? as? String)!
                contactEntity.firstName = record[kDWTContactABRecordFirstNameProperty] as AnyObject? as? String
                contactEntity.lastName = record[kDWTContactABRecordLastNameProperty] as AnyObject? as? String
                contactEntity.image = record[kDWTContactABRecordImageData] as AnyObject? as? NSData
                
                let phones = record[kDWTContactABRecordPhoneNumbers] as AnyObject? as? [[String : AnyObject]]
                
                var arr = phones?.map({ (phone: [String : AnyObject]) -> PhoneNumber in
                  var phoneEntity = context.createEntity(PhoneNumber.self) as PhoneNumber
                  phoneEntity.label = phone[kDWTContactABRecordPhoneLabel] as AnyObject? as String
                  phoneEntity.number = phone[kDWTContactABRecordPhoneNumber] as AnyObject? as String
                  return phoneEntity
                })
                
                contactEntity.phoneNumbers = NSSet(array: arr!)
                contacts.append(contactEntity)
              }
              
              }, completion: { (success, error) -> Void in
                completion(contacts, nil)
            })
          } else {
            println(err)
          }
        }
      }
    }
  }
}