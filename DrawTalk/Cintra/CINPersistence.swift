//
//  File.swift
//  Cintra
//
//  Created by Jacek Suliga on 11/7/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import Foundation

@objc
public class CINPersistence {

  // MARK: - Public interface
  
  /**
    Function used to register the concrete persistence delegate. 
    Must be called once, before any references to the defaultPersistence class method.
  */
  public class func registerDefaultPersistence(persistence: CINPersistenceProtocol) {
    CINAssert(CINPersistence.sharedInstance.persistenceDelegate == nil,
      "registerDefaultPersistence should be called only once!")
    
    CINPersistence.sharedInstance.persistenceDelegate = persistence
  }
  
  /**
    Returns the shared default persistence delegate.
    registerDefaultPersistence() must be called before any accesses to defaultPersistence()
  */
  public class var defaultPersistence: CINPersistenceProtocol? {
    CINAssert(CINPersistence.sharedInstance.persistenceDelegate != nil,
      "registerDefaultPersistence must be called once before accessing defaultPersistence!")
    
    return CINPersistence.sharedInstance.persistenceDelegate
  }

  
  
  // MARK: - Private interface

  // Persistence delegate reference
  weak var persistenceDelegate: CINPersistenceProtocol? = nil
  
  /**
    Singleton shared instance accessor.
  
    @return Returns the shared singleton instance
  */
  private class var sharedInstance: CINPersistence {
    struct Static {
      static let instance = CINPersistence()
    }
    return Static.instance
  }
  
}
