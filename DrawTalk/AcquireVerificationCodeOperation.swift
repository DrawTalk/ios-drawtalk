//
//  AcquireVerificationCodeOperation.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/1/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

struct AcquireVerificationCodeRequest: ServerRequest {
  let number: String
  
  func toJson() -> RequestJson {
    var json = [
      "phoneNumber": number,
    ]
    return json
  }
}

struct AcquireVerificationCodeResponse {
  let A: String?
}

/*!
Responsible for the initial verification of a phone number. Once executed, a verification code will
be sent to the specified phone number
*/
class AcquireVerificationCodeOperation: ApiOperation {
  private lazy var url: String = {
    return "\(Constants.apiUrl)/users/sendVerificationCode"
    }()
  
  private(set) var serverReponse: ServerResponse<AcquireVerificationCodeResponse>?
  
  override func main () {
    request(Alamofire.Method.POST, url, parameters: serverRequest.toJson(), encoding: .JSON)
      .responseJSON { (request, response, JSON, error) in
        var result = ServerResponse<AcquireVerificationCodeResponse>(
          result: AcquireVerificationCodeResponse(A: ""),
          error: error
        )
        self.finish(result)
    }
  }
  
  private func finish(result: ServerResponse<AcquireVerificationCodeResponse>) {
    self.serverReponse = result
    self.finish()
  }
}
