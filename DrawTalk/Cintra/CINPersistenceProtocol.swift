//
//  CINPersistenceProtocol.swift
//  Cintra
//
//  Created by Jacek Suliga on 11/5/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

// TODO: Consider adding support for wrapping NSFetchedResultsController

import Foundation

public typealias CINPersistenceHandler = (Bool, NSError?) -> Void

// MARK: - CINPersistenceContext

/**
  Protocol declaring operations that can be done in the persistence context.
*/
@objc
public protocol CINPersistenceContext {
  
  /** 
    Returns the object converted to this context.
  */
  func objectInContext(object: AnyObject?) -> AnyObject?
  
  /**
    Creates a new entity in this context.  
  */
  func createEntity(objClass: AnyClass) -> AnyObject?
  
  /**
    Finds object by the persistence object ID
  */
  func findObjectForClass(objClass: AnyClass!, withObjectID objectID: AnyObject!) -> AnyObject!

  /**
    Finds first object of the given class, matching the attribute=value condition, in the current context.
  */
  func findFirstForClass(objClass: AnyClass, attribute: String!, withValue value: AnyObject?) -> AnyObject?

  /**
    Finds first object of the given class, matching the given predicate, in the current context.
  */
  func findFirstForClass(objClass: AnyClass, withPredicate predicate: NSPredicate?, sortedBy: String?, ascending: Bool) -> AnyObject?
  
  /**
    Finds all objects of the given class, matching the given predicate, in the current context.
  */
  func findAllForClass(objClass: AnyClass, withPredicate predicate: NSPredicate?, sortedBy: String?, ascending: Bool, groupBy: String?) -> [AnyObject]?

  /**
    Deletes the given object from the storage, in the current context.
  */
  func deleteEntity(object: AnyObject?)
  
  /**
    Deletes all objects of the given class from the storage, in the current context.
  */
  func deleteAllEntities(objClass: AnyClass, matchingPredicate predicate: NSPredicate?)
}



// MARK: - CINPersistenceProtocol

/**
  Protocol declaring operations that can be done
*/
@objc
public protocol CINPersistenceProtocol {

  // MARK: - Saving operations
  
  /**
    Asynchronous save in the persistence storage, with completion handler.
    Use the context provided in the save block for all operations.
  */
  func save(saveBlock: (CINPersistenceContext!)->(), completion: CINPersistenceHandler?)
  
  /**
    Synchronous save in the persistence storage, blocking the current thread.
    Use the context provided in the save block for all operations.
  */
  func saveAndWait(saveBlock: (CINPersistenceContext!)->())

  /**
    Synchronously persists data to the peristed storage.
  */
  func persistData()
  
  
  // MARK: - Search operations
  
  /**
    Synchronous lookup for the first item of the given class, with the attribute = value.
    Uses the main context (protocol dependent) for lookup.
  */
  func findFirstForClass(objClass: AnyClass, attribute: String!, withValue value: AnyObject?) -> AnyObject?

  /**
    Synchronous lookup for all items of the given class matching the given predicate.
    Uses the main context (protocol dependent) for lookup.
  */
  func findAllForClass(objClass: AnyClass, withPredicate predicate: NSPredicate?, sortedBy: String?, ascending: Bool, groupBy: String?) -> [AnyObject]?
  
  /**
    Synchronous lookup for a grouped aggregate count for the given class on the attribute provided.
    Uses the main context (protocol dependent) for lookup.
  */
  func findCountGroupingForClass(objClass: AnyClass, attribute: String, withPredicate predicate: NSPredicate?, sortedBy: String?, ascending: Bool) -> [AnyObject]?

  
  
  // MARK: - Context operations
  
  /**
    Converts the given object into the main context.
  */
  func objectInContext(object: AnyObject?) -> AnyObject?
  
  /**
    Returns context for the given objects.
  */
  func contextForEntity(object: AnyObject?) -> CINPersistenceContext?
  
  
  // MARK: - General purpose
  
  /**
    Configures the storage for persisting data, if needed.
    resource and storage are protocol-specific resource names needed
    to configure the storage
  */
  func setupStorage(resource: String, storage: String)
  
  /**
    Deletes all persistence storage data. 
    @returns false on failure
  */
  func deleteStorage() -> Bool
  
  /**
    Protocol-specific clean up to be taken when the application is about to terminate.
  */
  func cleanUp()
  
  /**
    Protocol-specific check if the given object has been deleted from the storage.
   */
  func isEntityDeleted(object: AnyObject!) -> Bool
}