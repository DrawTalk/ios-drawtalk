//
//  CINCoreDataPersistence.swift
//  Cintra
//
//  Created by Jacek Suliga on 11/7/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CINCoreDataPersistenceContext


/**
Core Data persistence Context
*/
@objc
public class CINCoreDataPersistenceContext: CINPersistenceContext {
  var coreDataContext: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    coreDataContext = context
  }
  
  public func objectInContext(object: AnyObject?) -> AnyObject? {
    var obj = object as? NSManagedObject
    if let object: NSManagedObject = obj {
      return object.inContext(coreDataContext)
    } else {
      return object
    }
  }
  
  public func findObjectForClass(objClass: AnyClass!, withObjectID objectID: AnyObject!) -> AnyObject! {
    if let objClass = objClass as? NSManagedObject.Type {
      if let objID = objectID as? NSManagedObjectID {
        var error: NSError? = nil
        let result = coreDataContext.existingObjectWithID(objID, error: &error)
        
        return result
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
  
  public func findFirstForClass(objClass: AnyClass, attribute: String!, withValue value: AnyObject?) -> AnyObject? {
    if let objClass = objClass as? NSManagedObject.Type {
      return objClass.findFirstWithAttribute(attribute, value: value, context: coreDataContext)
    } else {
      return nil
    }
  }
  
  func findFirstForClass(objClass: AnyClass, withPredicate predicate: NSPredicate?) -> AnyObject? {
    if let objClass = objClass as? NSManagedObject.Type {
      if predicate != nil {
        return objClass.findFirstWithPredicate(predicate, context: coreDataContext)
      } else {
        return objClass.findFirstInContext(coreDataContext)
      }
    } else {
      return nil
    }
  }
  
  public func findFirstForClass(objClass: AnyClass, withPredicate predicate: NSPredicate?, sortedBy: String?, ascending: Bool) -> (AnyObject?) {
    if let objClass = objClass as? NSManagedObject.Type {
      return objClass.findFirstWithPredicate(predicate, sortedBy: sortedBy, ascending: ascending, context: coreDataContext)
    } else {
      return nil
    }
  }
  
  func findAllForClass(objClass: AnyClass, withPredicate predicate: NSPredicate?) -> [AnyObject]? {
    if let objClass = objClass as? NSManagedObject.Type {
      return objClass.findAllWithPredicate(predicate, context: coreDataContext)
    } else {
      return nil
    }
  }
  
  public func findAllForClass(objClass: AnyClass, withPredicate predicate: NSPredicate?, sortedBy: String?, ascending: Bool, groupBy: String?) -> [AnyObject]? {
    if let objClass = objClass as? NSManagedObject.Type {
      if groupBy != nil {
        let resultsController: NSFetchedResultsController = objClass.findAllGroupedBy(groupBy, predicate: predicate, sortedBy: sortedBy, ascending: ascending, context: coreDataContext)
        return resultsController.fetchedObjects
      } else {
        if predicate != nil {
          return objClass.findAllSortedBy(sortedBy, ascending: ascending, predicate: predicate, context: coreDataContext)
        } else {
          return objClass.findAllSortedBy(sortedBy, ascending: ascending, context: coreDataContext)
        }
      }
    } else {
      return nil
    }
  }
  
  public func createEntity(objClass: AnyClass) -> AnyObject? {
    if let objClass = objClass as? NSManagedObject.Type {
      return objClass.createInContext(coreDataContext)
    }
    return nil
  }
  
  public func deleteEntity(object: AnyObject?) {
    if let object = object as? NSManagedObject {
      object.deleteInContext(coreDataContext)
    }
  }
  
  public func deleteAllEntities(objClass: AnyClass, matchingPredicate predicate: NSPredicate?) {
    if let objClass = objClass as? NSManagedObject.Type {
      if predicate != nil {
        objClass.deleteAllMatchingPredicate(predicate, context: coreDataContext)
      } else {
        objClass.truncateAllInContext(coreDataContext)
      }
    }
  }
  
  func isEntityDeleted(object: AnyObject!) -> Bool {
    if let object = object as? NSManagedObject {
      return object.managedObjectContext == nil || object.deleted
    } else {
      return true
    }
  }
}


// MARK: - CINCoreDataPersistence

/**
Core Data persistence
*/
@objc
public class CINCoreDataPersistence: CINPersistenceProtocol {
  
  private var kResource = "Cintra"
  private var kDatabase = "Cintra.sqlite"
  
  private var managedObjectModel: NSManagedObjectModel!
  private var persistentStoreCoordinator: NSPersistentStoreCoordinator!
  
  // In-memory context
  private var mainContext: NSManagedObjectContext!
  
  // Context responsible for writing onto the persistence store
  private var writerContext: NSManagedObjectContext!
  
  private lazy var documentsDirectory: NSURL = {
    return NSFileManager.defaultManager().URLsForDirectory(
      NSSearchPathDirectory.DocumentDirectory,
      inDomains: NSSearchPathDomainMask.UserDomainMask).last as NSURL
    }()
  
  public class func sharedInstance() -> CINPersistenceProtocol {
    struct Static {
      static let instance = CINCoreDataPersistence()
    }
    return Static.instance
  }
  
  public func save(saveBlock: (CINPersistenceContext!)->(), completion: CINPersistenceHandler?) {
    
    // Logic:
    //  1. Create a private temporary context
    //     > the parentContext will be the main context
    //  2. Save the temporary context
    //     > since the main context is the parent of the temp context, once the temp context is saved, all changes
    //     > are committed to the main context
    //  3. Save the main context
    //
    
    var tempContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
    tempContext.parentContext = mainContext
    
    let handler = { (success: Bool, error: NSError?, contextName: String?) -> Void in
      if error != nil {
        CINLogging.logError("Unable to save \(contextName) context - \(error)")
      }
      completion?(success, error)
    }
    
    // Temporary
    tempContext.performBlock { () -> Void in
      var error: NSError? = nil
      saveBlock(CINCoreDataPersistenceContext(context: tempContext))
      // Need to obtain all permanent IDs, otherwise when if NSManagedObject is being retrieved
      // from mainContext, via objectInContext, it would return a null value, since the object
      // would only contain a temporary ID.
      self.obtainPermanentIDsBeforeSavingContext(tempContext)
      if tempContext.save(&error) {
        // Main
        self.mainContext.performBlock { () -> Void in
          var error: NSError? = nil
          if self.mainContext.save(&error) {
            handler(true, error, nil)
          } else {
            handler(false, error, "main")
          }
        }
      } else {
        handler(false, error, "temporary")
      }
    }
  }
  
  public func saveAndWait(saveBlock: (CINPersistenceContext!)->()) {
    var error: NSError? = nil
    saveAndWait(saveBlock, error: &error)
  }
  
  func saveAndWait(saveBlock: (CINPersistenceContext!)->(), error: NSErrorPointer) -> Bool {
    var tempContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
    tempContext.parentContext = mainContext
    
    // Temporary
    tempContext.performBlockAndWait { () -> Void in
      saveBlock(CINCoreDataPersistenceContext(context: tempContext))
      self.obtainPermanentIDsBeforeSavingContext(tempContext)
      if tempContext.save(error) {
        // Main
        self.mainContext.performBlockAndWait { () -> Void in
          if !self.mainContext.save(error) {
            CINLogging.logError("unable to save the main context: \(error)")
          }
        }
      } else {
        CINLogging.logError("unable to save the current context: \(error)")
      }
    }
    
    return error == nil
  }
  
  public func findFirstForClass(objClass: AnyClass, attribute: String!, withValue value: AnyObject?) -> AnyObject? {
    if let objClass = objClass as? NSManagedObject.Type {
      return objClass.findFirstWithAttribute(attribute, value: value, context: mainContext)
    } else {
      return nil
    }
  }
    
  public func findAllForClass(objClass: AnyClass, withPredicate predicate: NSPredicate?, sortedBy: String?, ascending: Bool, groupBy: String?) -> [AnyObject]? {
    if let objClass = objClass as? NSManagedObject.Type {
      if groupBy != nil {
        let resultsController: NSFetchedResultsController = objClass.findAllGroupedBy(groupBy, predicate: predicate, sortedBy: sortedBy, ascending: ascending, context: mainContext)
        return resultsController.fetchedObjects
      } else {
        if sortedBy != nil {
          return objClass.findAllSortedBy(sortedBy, ascending: ascending, predicate: predicate, context: mainContext)
        } else {
          return objClass.findAllWithPredicate(predicate, context: mainContext)
        }
      }
    } else {
      return nil
    }
  }
  
  public func findCountGroupingForClass(objClass: AnyClass, attribute: String, withPredicate predicate: NSPredicate?, sortedBy: String?, ascending: Bool) -> [AnyObject]? {
    if let objClass = objClass as? NSManagedObject.Type {
      return objClass.findCountGroupingForAttribute(attribute, keyPath: "contactId", ascending: ascending, predicate: predicate, context: mainContext)
    } else {
      return nil
    }
    
  }
  
  public func objectInContext(object: AnyObject?) -> AnyObject? {
    if let object = object as? NSManagedObject {
      return object.inContext(mainContext)
    } else {
      return object
    }
  }
  
  public func persistData() {
    // To persist the data, the main context is saved, and withint it, the write context
    
    // Main
    self.mainContext.performBlockAndWait { () -> Void in
      var errorR: NSError? = nil
      if self.mainContext.save(&errorR) {
        // Writer
        self.writerContext.performBlockAndWait { () -> Void in
          var errorW: NSError? = nil
          if self.writerContext.save(&errorW) {
            CINLogging.logInfo("Persisted data to storage")
          } else {
            CINLogging.logError("unable to save the  writer context: \(errorW)")
          }
        }
      } else {
        CINLogging.logError("unable to save the main context: \(errorR)")
      }
    }
  }

  
  public func deleteStorage() -> Bool {
    CINLogging.logDebug("Deleting storage")
    
    cleanUp()
    
    let storeURL = documentsDirectory.URLByAppendingPathComponent(kDatabase)
    let fileManager = NSFileManager.defaultManager()
    
    var error: NSError? = nil
    if let path = storeURL.path {
      if fileManager.fileExistsAtPath(path) {
        fileManager.removeItemAtURL(storeURL, error: &error)
      } else {
        CINLogging.logDebug("Storage not found: \(path)")
      }
    }
    
    if error != nil {
      CINLogging.logError("Error while deleting storage: \(error)")
    }
    
    return error == nil
  }
  
  public func setupStorage(resource: String, storage: String) {
    managedObjectModel = {
      self.kResource = resource
      self.kDatabase = storage
      
      let url = NSBundle.mainBundle().URLForResource(self.kResource, withExtension: "momd")
      return NSManagedObjectModel(contentsOfURL: url!)
      }()
    
    persistentStoreCoordinator = {
      // Create the coordinator and store
      var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel!)
      let storeURL = self.documentsDirectory.URLByAppendingPathComponent(self.kDatabase)
      
      CINLogging.logVerbose("DB Store URL: \(storeURL)")
      
      var error: NSError? = nil
      var store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: self.autoMigrationOptions(), error: &error)
      if store == nil {
        // The next logic is to handle re-creation of the DB whenever a failure in migration occurs.
        if let err = error {
          CINLogging.logDebug("Failed to create store. Attempting re-creation...")
          let isMigrationError = err.code == NSPersistentStoreIncompatibleVersionHashError || err.code == NSMigrationMissingSourceModelError
          if (err.domain == NSCocoaErrorDomain) && isMigrationError {
            // Could not open the current db, so let's remove it and create a new one
            if NSFileManager.defaultManager().removeItemAtURL(storeURL, error: &error) {
              CINLogging.logDebug("Removed incompatible model version: \(storeURL.lastPathComponent)")
              store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: self.autoMigrationOptions(), error: &error)
              if store == nil {
                CINLogging.logError("Failed to create store, \(error)")
              } else {
                error = nil
              }
            }
          }
        }
      }
      
      if error != nil {
        CINLogging.logError("Fatal error: unable to load load database: \(error)")
      }
      
      return coordinator
      }()
    
    writerContext = {
      var ctx: NSManagedObjectContext!
      if let coordinator = self.persistentStoreCoordinator {
        ctx = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        ctx.persistentStoreCoordinator = coordinator
      }
      return ctx
      }()
    
    mainContext = {
      var ctx = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
      ctx.parentContext = self.writerContext
      return ctx
      }()
  }
  
  public func cleanUp() {
    mainContext = nil
    writerContext = nil
    persistentStoreCoordinator = nil
    managedObjectModel = nil
  }
  
  public func isEntityDeleted(object: AnyObject!) -> Bool {
    if let object = object as? NSManagedObject {
      return object.managedObjectContext == nil || object.deleted
    } else {
      return true
    }
  }
  
  public func contextForEntity(object: AnyObject?) -> CINPersistenceContext? {
    if let object = object as? NSManagedObject {
      if let objContext = object.managedObjectContext {
        return CINCoreDataPersistenceContext(context: objContext)
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
  
  // PRIVATE
  
  private func autoMigrationOptions() -> [NSObject : AnyObject]? {
    let options = [
      NSMigratePersistentStoresAutomaticallyOption: true,
      NSInferMappingModelAutomaticallyOption: true,
      // Adding the journalling mode recommended by apple
      NSSQLitePragmasOption: [
        "journal_mode": "WAL"
      ]
    ]
    return options
  }
  
  private func obtainPermanentIDsBeforeSavingContext(context: NSManagedObjectContext) {
    let insertedObjects = context.insertedObjects
    if insertedObjects.count > 0 {
      CINLogging.logInfo("Context is about to save. Obtaining pemanent IDs for \(insertedObjects.count) new inserted objects")
      var error: NSError? = nil
      if !context.obtainPermanentIDsForObjects(insertedObjects.allObjects, error: &error) {
        CINLogging.logError("Error while obtaining permanent IDs: \(error)")
      }
    }
  }
  
}

/**
Extension methods on NSManagedObject, for requests, selectors, and helpers
*/
extension NSManagedObject {
  
  class func entityName() -> String {
    return NSStringFromClass(self)
  }
  
  class func entityDescription(context: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entityForName(entityName(), inManagedObjectContext: context)
  }
  
  class func createInContext(context: NSManagedObjectContext) -> AnyObject {
    return NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: context)
  }
  
  func inContext(context: NSManagedObjectContext) -> NSManagedObject? {
    var error: NSError? = nil
    var object: NSManagedObject? = context.existingObjectWithID(self.objectID, error:&error)
    if error != nil {
      CINLogging.logError("error while loading oject from context: \(error), object: \(self), obectID: \(self.objectID)")
    }
    return object
  }
}

// Delete
extension NSManagedObject {
  
  func deleteInContext(context: NSManagedObjectContext) {
    context.deleteObject(self)
  }
  
  class func deleteAllMatchingPredicate(predicate: NSPredicate?, context: NSManagedObjectContext) -> Bool {
    var request = requestAllWithPredicate(predicate, context: context)
    request.returnsObjectsAsFaults = true
    request.includesPropertyValues = false
    let entities = executeRequest(request, context: context)
    for entity:AnyObject in entities! {
      entity.deleteInContext(context)
    }
    return true
  }
  
  class func truncateAllInContext(context: NSManagedObjectContext) -> Bool {
    let entities = findAllInContext(context)
    for entity:AnyObject in entities! {
      entity.deleteInContext(context)
    }
    return true
  }
  
}

// Requests
extension NSManagedObject {
  
  class func executeRequest(request: NSFetchRequest, context: NSManagedObjectContext) -> [AnyObject]? {
    var results: [AnyObject]?
    context.performBlockAndWait { () -> Void in
      var error: NSError? = nil
      results = context.executeFetchRequest(request, error: &error)
    }
    return results
  }
  
  class func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest {
    var request = NSFetchRequest()
    request.entity = entityDescription(context)
    return request
  }
  
  class func requestAllWhereAttribute(attribute: String, equalTo: AnyObject?, context: NSManagedObjectContext) -> NSFetchRequest {
    var request = createFetchRequest(context)
    
    if let value = (equalTo as? NSObject) {
      request.predicate = NSPredicate(format: "%K = %@", attribute, value)
    } else {
      request.predicate = NSPredicate(format: "%K = NULL")
    }
    
    return request
  }
  
  class func requestFirstWithAttribute(attribute: String, value: AnyObject?, context: NSManagedObjectContext) -> NSFetchRequest {
    var request = requestAllWhereAttribute(attribute, equalTo: value, context: context)
    request.fetchLimit = 1
    return request
  }
  
  class func requestAllSortedBy(sortedBy: String?, ascending: Bool, context: NSManagedObjectContext) -> NSFetchRequest {
    return requestAllSortedBy(sortedBy, ascending: ascending, predicate: nil, context: context)
  }
  
  class func requestAllSortedBy(sortedBy: String?, ascending: Bool, predicate: NSPredicate?, context: NSManagedObjectContext) -> NSFetchRequest {
    var request = createFetchRequest(context)
    if predicate != nil {
      request.predicate = predicate
    }
    if sortedBy != nil {
      let sortKeys = split(sortedBy!, { $0 == ","}, maxSplit: Int.max, allowEmptySlices: false)
      let sortDescriptors = sortKeys.map({ (key: String) -> NSSortDescriptor in
        return NSSortDescriptor(key: key, ascending: ascending)
      })
      request.sortDescriptors = sortDescriptors
    }
    return request
  }
  
  class func requestAllWithPredicate(predicate: NSPredicate?, context: NSManagedObjectContext) -> NSFetchRequest {
    var request = createFetchRequest(context)
    request.predicate = predicate
    return request
  }
}

// Queries
extension NSManagedObject {
  
  class func findFirstInContext(context: NSManagedObjectContext) -> AnyObject? {
    var request = createFetchRequest(context)
    request.fetchLimit = 1
    let results = executeRequest(request, context: context)
    return results?.first
  }
  
  class func findFirstWithAttribute(attribute: String, value: AnyObject?, context: NSManagedObjectContext) -> AnyObject? {
    let request = requestFirstWithAttribute(attribute, value: value, context: context)
    let results = executeRequest(request, context: context)
    return results?.first
  }
  
  class func findFirstWithPredicate(predicate: NSPredicate?, context: NSManagedObjectContext) -> AnyObject? {
    var request = createFetchRequest(context)
    if predicate != nil {
      request.predicate = predicate
    }
    request.fetchLimit = 1
    let results = executeRequest(request, context: context)
    return results?.first
  }
  
  class func findAllInContext(context: NSManagedObjectContext) -> [AnyObject]? {
    return executeRequest(createFetchRequest(context), context: context)
  }
  
  class func findFirstWithPredicate(predicate: NSPredicate?, sortedBy: String?, ascending: Bool, context: NSManagedObjectContext) -> AnyObject? {
    let request = requestAllSortedBy(sortedBy, ascending: ascending, predicate: predicate, context: context)
    let results = executeRequest(request, context: context)
    return results?.first
  }
  
  class func findAllWithPredicate(predicate: NSPredicate?, context: NSManagedObjectContext) -> [AnyObject]? {
    var request = createFetchRequest(context)
    if predicate != nil {
      request.predicate = predicate
    }
    let results = executeRequest(request, context: context)
    return results
  }
  
  class func findAllSortedBy(sortedBy: String?, ascending: Bool, context: NSManagedObjectContext) -> [AnyObject]? {
    var request = requestAllSortedBy(sortedBy, ascending: ascending, context: context)
    return executeRequest(request, context: context)
  }
  
  class func findAllSortedBy(sortedBy: String?, ascending: Bool, predicate: NSPredicate?, context: NSManagedObjectContext) -> [AnyObject]? {
    var request = requestAllSortedBy(sortedBy, ascending: ascending, predicate: predicate, context: context)
    return executeRequest(request, context: context)
  }
  
  class func findAllGroupedBy(groupBy: String?, predicate: NSPredicate?, sortedBy: String?, ascending: Bool, context: NSManagedObjectContext) -> NSFetchedResultsController {
    
    var request = requestAllSortedBy(sortedBy, ascending: ascending, context: context)
    let controller = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: context,
      sectionNameKeyPath: groupBy,
      cacheName: nil)
    
    var error: NSError? = nil
    controller.performFetch(&error)
    
    return controller
  }
  
  class func findCountGroupingForAttribute(attribute: String, keyPath: String, ascending: Bool, predicate: NSPredicate?, context: NSManagedObjectContext) -> [AnyObject]? {
    
    // Basically, what we want to achieve in this entire function is akin to the execution of the
    // following SQL statement:
    //
    //  SELECT `attribute`, COUNT(*) AS count FROM `LCNContact` GROUP BY `attribute`
    //
    // Thereby getting a pretty table like this:
    //
    //  attribute  | count
    //  ------------------
    //  attribute1 | 3
    //  attribute2 | 1
    //
    // But of course, using Core Data, things are seldom this simple.  Case in point - the above trivial query
    // morphs into a grotesque monstrosity deserving nothing but the profoundest contempt.
    //
    
    let entity = entityDescription(context)
    let keyPathExpression = NSExpression(forKeyPath: keyPath)
    let countExpression = NSExpression(forFunction: "count", arguments: [keyPathExpression])
    let attributeDescription: NSAttributeDescription = entity!.attributesByName[attribute] as NSAttributeDescription
    let expressionDescription = NSExpressionDescription()
    let countSortDescriptor = NSSortDescriptor(key: attribute, ascending: ascending, selector: Selector("localizedCaseInsensitiveCompare"))
    
    expressionDescription.name = "count"
    expressionDescription.expression = countExpression
    expressionDescription.expressionResultType =  NSAttributeType.Integer32AttributeType
    
    var request = createFetchRequest(context)
    
    if predicate != nil {
      request.predicate = predicate
    }
    
    request.propertiesToFetch = [attributeDescription, expressionDescription]
    request.propertiesToGroupBy = [attributeDescription]
    request.resultType = NSFetchRequestResultType.DictionaryResultType
    request.sortDescriptors = [countSortDescriptor]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    var error: NSError? = nil
    fetchedResultsController.performFetch(&error)
    
    return fetchedResultsController.fetchedObjects
  }
}
