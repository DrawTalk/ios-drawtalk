//
//  PhoneNumberVerificationOperation.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/31/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

// Responses

struct ServerResponse<T> {
  let result: T?
  let error: NSError?
}

struct PhoneNumberVerificationResult {
  let item: String?
}

struct PhoneNumberVerificationCodeResult {
  let item: String?
}

// Requests

protocol ServerRequest {
  func toJson() -> [String: AnyObject]?
}

struct PhoneNumberRequest: ServerRequest {
  let number: String
  
  func toJson() -> [String: AnyObject]? {
    var json = [
      "phoneNumber": number,
    ]
    return json
  }
}

struct PhoneNumberVerificationRequest: ServerRequest {
  let number: String
  let code: String
  
  func toJson() -> [String: AnyObject]? {
    var json = [
      "phoneNumber": number,
      "code": code
    ]
    return json
  }
}

class ApiOperation: ConcurrentOperation {
  private let serverRequest: ServerRequest!

  init(serverRequest: ServerRequest) {
    super.init()
    self.serverRequest = serverRequest
  }
  
  private func finish() {
    self.state = .Finished
  }
}

class SendVerificationOperation: ApiOperation {
  
  private(set) var serverReponse: ServerResponse<PhoneNumberVerificationResult>?
  
  override func main () {
    
    var url = "\(Constants.apiUrl)/users/sendVerificationCode"

    request(Alamofire.Method.POST, url, parameters: serverRequest.toJson(), encoding: .JSON)
      .responseJSON { (request, response, JSON, error) in
        var result = ServerResponse<PhoneNumberVerificationResult>(
          result: PhoneNumberVerificationResult(item: ""),
          error: error
        )
        self.finish(result)
    }
  }
  
  private func finish(result: ServerResponse<PhoneNumberVerificationResult>) {
    self.serverReponse = result
    self.finish()
  }
}

class PhoneNumberVerificationOperation: ApiOperation {
  
  private(set) var serverReponse: ServerResponse<PhoneNumberVerificationCodeResult>?
  
  override func main () {
    var url = "\(Constants.apiUrl)/users/verifyPhoneNumber"
    
    request(Alamofire.Method.POST, url, parameters: serverRequest.toJson(), encoding: .JSON)
      .responseJSON { (request, response, JSON, error) in
        var result = ServerResponse<PhoneNumberVerificationCodeResult>(
          result: PhoneNumberVerificationCodeResult(item: ""),
          error: error
        )
        self.finish(result)
    }
  }
  
  private func finish(result: ServerResponse<PhoneNumberVerificationCodeResult>) {
    self.serverReponse = result
    self.finish()
  }
}