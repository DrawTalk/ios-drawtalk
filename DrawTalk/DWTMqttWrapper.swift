//
//  DWTMqttWrapper.swift
//  DrawTalk
//
//  Created by Roman Inozemtsev on 10/11/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

var sharedMqttWrapper: DWTMqttWrapper? = nil

public class DWTMqttWrapper {
  
  // tcp:// or mqtt://
  let host = "m10.cloudmqtt.com"
  let port : UInt16 = 16056
  let username = "vkgogxez"
  let password = "oX02eF7V0I9Y"
  let topic = "hello/world"
  let qos2 = 2
  
  let client: MQTTClient
  let clientId: String
  
  init() {
    clientId = UIDevice.currentDevice().identifierForVendor.UUIDString
    client = MQTTClient(clientId: clientId)
    
    client.username = username
    client.password = password
    client.host = host
    client.port = port

    client.connectWithCompletionHandler { (code: MQTTConnectionReturnCode) -> Void in
      switch code.value {
      case ConnectionAccepted.value:
        println("successfully connected")
      default:
        println("wtf is the code!")
        break
      }
    }
    
    client.subscribe(topic, withCompletionHandler: { ([AnyObject]!) -> Void in
      println("subscribed to the topic")
    })
    
    client.messageHandler = { (message: MQTTMessage!) -> Void in
      println(message.payload)
    }
  }
  
  class func create() {
    println("CREATING CLIENT")
    sharedMqttWrapper = DWTMqttWrapper()
  }
  
  // message would be json serialized drawing
  class func sendMessage(message: String) {
    sharedMqttWrapper?.sendMessage(message)
  }
  
  func sendMessage(message: String) {
    
    let messageId = NSUUID.UUID().UUIDString
    let payload = ["message": message, "clientId": clientId, "id": messageId]

    var jsonError: NSError?
    let encodedJsonData: NSData? = NSJSONSerialization.dataWithJSONObject(payload, options: nil, error: &jsonError)
    let encodedJsonString: NSString = NSString(data:encodedJsonData!, encoding:NSUTF8StringEncoding)

    
    
    println("sending")
    println(encodedJsonString);

            client.publishString(
              encodedJsonString,
              toTopic: topic,
              withQos: ExactlyOnce,
              retain: false,
              completionHandler: { (mid: Int32) -> Void in
              })
  }
}