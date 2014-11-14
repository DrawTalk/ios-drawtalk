//
//  ContactsDecorator.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/14/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

class ContactsTokenDecorator {
  private let contacts: [Contact]!
  
  init(_ contacts: [Contact]) {
    self.contacts = contacts
  }
  
  func decorate(completion: (Bool, NSError?) -> Void) {
    // Get all phone numbers for all the contacts, into a single flat list
    var allPhoneNumbers = [String]()
    for contact: Contact in contacts {
      if let numbers = contact.phoneNumbers {
        for phoneNumber: PhoneNumber in numbers {
          allPhoneNumbers.append(phoneNumber.number)
        }
      }
    }
    
    // Perform a contacts lookup, to retrieve the tokens
    var queue = NSOperationQueue()
    let request = ContactsLookupRequest(phoneNumbers: allPhoneNumbers)
    var operation = ContactsLookupOperation(serverRequest: request)
    operation.completionBlock = {
      dispatch_async(dispatch_get_main_queue(), {
        let response: ServerResponse<ContactsLookupResponse>? = operation.serverReponse
        if let error = response?.error {
          completion(false, error)
        } else {
          let tokens = response?.result?.tokens
          for contact: Contact in self.contacts {
            if let numbers = contact.phoneNumbers {
              for phoneNumber: PhoneNumber in numbers {
                if let token = tokens?[phoneNumber.number] {
                  contact.token = token
                  break
                }
              }
            }
          }
          completion(true, nil)
        }
      })
    }
    queue.addOperation(operation)
  }
}