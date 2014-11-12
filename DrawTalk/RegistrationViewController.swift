//
//  RegistrationViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

protocol RegistrationViewControllerDelegate {
  func registration(controller: RegistrationViewController, registerWithPhoneNumber phoneNumber: String)
  func registration(controller: RegistrationViewController, verifyWithCode code: String)
}

class RegistrationViewController: UIViewController {
  
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var sendButton: UIButton!
  
  @IBOutlet weak var codeTextField: UITextField!
  @IBOutlet weak var verifyButton: UIButton!
  
  var phoneNumber: String?
  var delegate: RegistrationViewControllerDelegate?
  
  class func controller() -> RegistrationViewController {
    let vc = RegistrationViewController(nibName:"RegistrationViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let phoneNumber = phoneNumber {
      phoneNumberTextField.text = phoneNumber
    }
  }
  
  @IBAction func sendButtonTapped(sender : AnyObject) {
    let phoneNumber: String = phoneNumberTextField.text
    delegate?.registration(self, registerWithPhoneNumber: phoneNumber)
  }
  
  @IBAction func verifyButtonTapped(sender : AnyObject) {
    let code: String = codeTextField.text
    delegate?.registration(self, verifyWithCode: code);
  }
  
}
