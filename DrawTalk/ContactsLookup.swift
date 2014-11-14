//
//  FetchKnownContacts.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/13/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

struct ContactsLookupRequest: ServerRequest {
  let phoneNumbers: [String]
  
  func toJson() -> RequestJson {
    var json = [
      "phoneNumbers": phoneNumbers,
    ]
    return json
  }
}

struct ContactsLookupResponse {
  let tokens: [String : String]
  
  func tokenForPhoneNumber(phone: String) -> String? {
    return tokens[phone]
  }
  
  static func fromJson(json: AnyObject?) -> ContactsLookupResponse? {
    if let j: AnyObject = json {
      let json = JSON(j)
      let pairs = json["phoneTokens"].dictionaryObject!
      return ContactsLookupResponse(tokens: pairs as [String : String])
    }
    return nil
  }
}

/*!
Responsible for the initial verification of a phone number. Once executed, a verification code will
be sent to the specified phone number
*/
class ContactsLookupOperation: ApiOperation {
  private lazy var url: String = {
    return "\(Constants.apiUrl)/users/checkContacts"
    }()
  
  private(set) var serverReponse: ServerResponse<ContactsLookupResponse>?
  
  override func main () {
    request(Alamofire.Method.POST, url, parameters: serverRequest.toJson(), encoding: .JSON)
      .responseJSON { (request, response, JSON, error) in
        print(JSON)
        var result = ServerResponse<ContactsLookupResponse>(
          result: ContactsLookupResponse.fromJson(JSON),
          error: error
        )
        self.finish(result)
    }
  }
  
  private func finish(result: ServerResponse<ContactsLookupResponse>) {
    self.serverReponse = result
    self.finish()
  }
}
