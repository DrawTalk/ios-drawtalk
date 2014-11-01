//
//  SendVerificationCodeOperation.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/1/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

struct SendVerificationCodeRequest: ServerRequest {
  let number: String
  let code: String
  
  func toJson() -> RequestJson {
    var json = [
      "phoneNumber": number,
      "code": code
    ]
    return json
  }
}

struct SendVerificationCodeResponse {
  let B: String?
}

/*!
Responsible for verifying a phone number with the verification code provided
*/
class SendVerificationCodeOperation: ApiOperation {
  
  private lazy var url: String = {
    return "\(Constants.apiUrl)/users/verifyPhoneNumber"
    }()
  
  private(set) var serverReponse: ServerResponse<SendVerificationCodeResponse>?
  
  override func main () {
    request(Alamofire.Method.POST, url, parameters: serverRequest.toJson(), encoding: .JSON)
      .responseJSON { (request, response, JSON, error) in
        var result = ServerResponse<SendVerificationCodeResponse>(
          result: SendVerificationCodeResponse(B: ""),
          error: error
        )
        self.finish(result)
    }
  }
  
  private func finish(result: ServerResponse<SendVerificationCodeResponse>) {
    self.serverReponse = result
    self.finish()
  }
}