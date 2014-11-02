//
//  DWTMqqtClientWrapper.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

// https://github.com/mobile-web-messaging/MQTTKit

import Foundation
import UIKit

public class MqttClientWrapper {
  
  private let topic = "6504047096"
  private let client: MQTTClient
  private let clientId: String
  
  class var defaultMQTT: MqttClientWrapper {
  struct Static {
    static let instance = MqttClientWrapper()
    }
    return Static.instance
  }
  
  init() {
    clientId = UIDevice.currentDevice().identifierForVendor.UUIDString
    client = MQTTClient(clientId: clientId)
  }
  
  public func setup(#username: String, password: String, host: String, port: UInt16) {
    client.username = username
    client.password = password
    client.host = host
    client.port = port
    
    client.connectWithCompletionHandler { (code: MQTTConnectionReturnCode) -> Void in
      switch code.value {
      case ConnectionAccepted.value:
        println("successfully connected")
      default:
        println("wtf is this code!")
        break
      }
    }

    client.subscribe(Constants.topicPrefix + "6504047096", withCompletionHandler: { ([AnyObject]!) -> Void in
      println("subscribed to the topic")
    })
    
    MessageEventBus.defaultBus.subscribe(kMessageEventOutgoing, handler: { (event: MessageEvent) -> Void in
      var message: AnyObject = event.toPayload()
      self.sendMessage(message)
    })
    
    client.messageHandler = { (message: MQTTMessage!) -> Void in
      let m = ChatMessage.incoming(message.payload)
      //if m.clientId != self.clientId {
        MessageEventBus.defaultBus.post(kMessageEventIncoming, event: m)
      //}
    }
  }
  
  // message would be json serialized drawing
  private func sendMessage(payload: AnyObject) {
    var jsonError: NSError?
    let encodedJsonData: NSData? = NSJSONSerialization.dataWithJSONObject(payload, options: nil, error: &jsonError)
    let encodedJsonString: NSString = NSString(data:encodedJsonData!, encoding:NSUTF8StringEncoding)!
    
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