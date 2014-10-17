//
//  DWTMqttWrapper.swift
//  DrawTalk
//
//  Created by Roman Inozemtsev on 10/11/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

public class DWTMqttWrapper {
  
  // tcp:// or mqtt://
  private let host = "m10.cloudmqtt.com"
  private let port : UInt16 = 16056
  private let username = "vkgogxez"
  private let password = "oX02eF7V0I9Y"
  private let topic = "hello/world"
  
  private let client: MQTTClient
  private let clientId: String
  
  class var defaultMQTT: DWTMqttWrapper {
    struct Static {
      static let instance = DWTMqttWrapper()
    }
    return Static.instance
  }
  
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
      println("PAYLOAD")
      
      /*
      var data: NSData = jsonStringAsArray.dataUsingEncoding(NSUTF8StringEncoding)!
      var error: NSError?
      
      var jsonError: NSError?
      let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(message.payload, options: nil, error: &jsonError)
      
      let dict = json as Dictionary<String, AnyObject>
      let result: AnyObject? = NSJSONSerialization.JSONObjectWithData(dict["message"], options: nil, error: &jsonError)

      //DrawTalk.Path.fromJSON()
      
      println(jsonData)
      println(result)
      
      */
      // TODO: deserialize and replay it here
      // please note, that since we are subscribed to the same topic we are sending to.
      // we will also receive our send here.
      // which is good for testing purposes, but then we can just ignore it using "clientId" from the payload
      // see the serialization defailt on line 72 here.
      //
    }
  }

  // message would be json serialized drawing
  class func sendMessage(message: String) {
    DWTMqttWrapper.defaultMQTT.sendMessage(message)
  }
  
  private func sendMessage(message: String) {
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
        println("message has been delivered: \(mid)");
    })
  }
}