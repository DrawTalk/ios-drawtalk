//
//  ConversationViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController : UIViewController, MessageCollectionDataSourceDelegate {
  
  @IBOutlet weak var messageContainerView: UIView!
  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var sendButton: UIButton!
  
  private var messageController: MessageCollectionViewController!
  
  private var channel: String!
  private var contact: Contact!
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  class func controller(#channel: String, contact: Contact) -> ConversationViewController {
    let vc = ConversationViewController(nibName:"ConversationViewController", bundle: nil)
    vc.channel = channel
    vc.contact = contact
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    messageController = MessageCollectionViewController.controller()
    addChildViewController(messageController)
    messageContainerView.addSubview(messageController.view)
    messageController.didMoveToParentViewController(self)
    messageController.messageCollectionDataSource.messageCollectionDelegate = self
    
    //canvasView.viewOnly = true
    
    observerMessagingEvent()
  }
  
  func didSelectMessage(drawing: Drawing) {
    canvasView.replay(drawing, animated: true)
  }
  
  
  @IBAction func resetButtonTapped(sender : AnyObject) {
    canvasView.reset()
  }
  
  @IBAction func replayButtonTapped(sender : AnyObject) {
    canvasView.replay()
  }
  
  @IBAction func sendButtonTapped(sender : AnyObject) {
    let drawing = canvasView.drawing()
    let drawingJson = DrawingJson(drawing: drawing)
    var message = ChatMessage.outgoing(drawingJson.jsonString(), channel: contact.token!)
    MessageEventBus.defaultBus.post(kMessageEventOutgoing, event: message)
    messageController.messageCollectionDataSource.addDrawing(drawing)
  }
  
  private func observerMessagingEvent() {
    MessageEventBus.defaultBus.subscribe(kMessageEventIncoming, handler: { (event: MessageEvent) -> Void in
      let chatMessage = event as ChatMessage
      if chatMessage.channel == self.channel {
        var d = JSON(data: chatMessage.text.dataUsingEncoding(NSUTF8StringEncoding)!)
        var drawingJson =  DrawingJson(json: d)
        dispatch_async(dispatch_get_main_queue(), {
          var drawing = drawingJson.toDrawing()
          self.messageController.messageCollectionDataSource.addDrawing(drawing)
        })
      }
    })
  }
  
}
