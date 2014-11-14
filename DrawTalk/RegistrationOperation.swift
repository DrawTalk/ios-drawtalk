//
//  AuthenticationOperation.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class RegistrationOperation: ConcurrentOperation, RegistrationViewControllerDelegate {
  
  var controller: UIViewController!
  
  override func main () {
    var queue = NSOperationQueue()
    
    if let user = AppSession.mainSession.currentUser {
      // Unverified user:
      // Need to obetain send verification code
      if user.state == UserState.Unverified {
        showRegistrationAnimated(false)
      } else {
        // Verified user
        finish()
      }
    } else {
      // No user:
      showRegistrationAnimated(false)
    }
  }
  
  func finish() {
    self.state = .Finished
  }
  
  private func showRegistrationAnimated(animated: Bool) {
    weak var weakSelf: RegistrationOperation? = self
    dispatch_async(dispatch_get_main_queue(), {
      let ctrl = RegistrationViewController.controller()
      ctrl.delegate = weakSelf
      ctrl.phoneNumber = AppSession.mainSession.currentUser?.phoneNumber
      let nav = UINavigationController(rootViewController: ctrl)
      weakSelf?.controller.presentViewController(nav, animated: animated, completion: nil)
    });
  }
  
  // MARK: - RegistrationViewController delegates
  
  func registration(controller: RegistrationViewController, registerWithPhoneNumber phoneNumber: String) {
    // Acquire verification code
    var queue = NSOperationQueue()
    let request = AcquireVerificationCodeRequest(phoneNumber: phoneNumber)
    var operation = AcquireVerificationCodeOperation(serverRequest: request)
    operation.completionBlock = {
      let user = User()
      user.phoneNumber = phoneNumber
      AppSession.mainSession.saveUser(user)
    }
    queue.addOperation(operation)
  }
  
  func registration(controller: RegistrationViewController, verifyWithCode code: String) {
    // Send verification code
    weak var weakSelf:RegistrationOperation? = self
    var queue = NSOperationQueue()
    let user = AppSession.mainSession.currentUser!
    let request = SendVerificationCodeRequest(phoneNumber: user.phoneNumber!, code: code)
    var operation = SendVerificationCodeOperation(serverRequest: request)
    operation.completionBlock = {
      let response: ServerResponse<SendVerificationCodeResponse>? = operation.serverReponse
      if let result = response?.result? {
        user.phoneNumber = result.phoneNumber
        user.userKey = result.userKey
        user.privateToken = result.privateToken
        AppSession.mainSession.logUserIn(user)
      } else {
        self.showError(response?.error, inController: controller)
      }
      weakSelf?.finish()
    }
    queue.addOperation(operation)
  }
  
  private func showError(error: NSError?, inController controller: UIViewController) {
    dispatch_async(dispatch_get_main_queue(), {
      
      let title = DWTLocalizedStringWithDefaultValue(
        "registration.verification.alert.title",
        tableName: "Localizable",
        bundle: NSBundle.mainBundle(),
        value: "Ooops!",
        comment: "Title for verification screen alert error")
      
      let message = DWTLocalizedStringWithDefaultValue(
        "registration.verification.alert.message",
        tableName: "Localizable",
        bundle: NSBundle.mainBundle(),
        value: "Looks like something went wrong. Try sending the code again",
        comment: "Message for verification screen alert error")
      
      var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
      controller.presentViewController(alert, animated: true, completion: nil)
    })
  }
  
}