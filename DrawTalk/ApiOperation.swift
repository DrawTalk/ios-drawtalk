//
//  PhoneNumberVerificationOperation.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/31/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

//struct ServerRequests {}
//struct ServerResponses {}

// MARK: - Request

typealias RequestJson = [String: AnyObject]?

protocol ServerRequest {
  func toJson() -> RequestJson
}

// MARK: - Response

struct ServerResponse<T> {
  let result: T?
  let error: NSError?
}

// MARK: - API Operations

class ApiOperation: ConcurrentOperation {
  private(set) var serverRequest: ServerRequest!
  
  init(serverRequest: ServerRequest) {
    super.init()
    self.serverRequest = serverRequest
  }
  
  func finish() {
    self.state = .Finished
  }
}

