//
//  CINAssert.swift
//  Cintra
//
//  Created by Jacek Suliga on 11/7/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import Foundation

/**
  Assertion function for Swift. Logs and asserts.
*/
public func CINAssert(condition: @autoclosure () -> Bool, message: String) {
  if !condition() {
    CINLogging.logError(message)
  }
  assert(condition, "\(message)")
}
