//
//  ConversationViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController : UIViewController, MessageCollectionDelegate {

  @IBOutlet weak var messageContainerView: UIView!
  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var sendButton: UIButton!

  private var messageController: MessageCollectionViewController!

  private var contact: Contact!

  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  class func controller(#contact: Contact) -> ChatViewController {
    let vc = ChatViewController(nibName:"ChatViewController", bundle: nil)
    vc.contact = contact
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    messageController = MessageCollectionViewController.controller()
    addChildViewController(messageController)
    messageContainerView.addSubview(messageController.view)
    messageController.didMoveToParentViewController(self)
    messageController.messageCollectionDelegate = self

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
    var message = Message.outgoing(drawingJson.jsonString(), channel: contact.channel!)
    MessageEventBus.defaultBus.post(.Outgoing, message: message)
    messageController.addDrawing(drawing)
  }

  private func observerMessagingEvent() {
    MessageEventBus.defaultBus.subscribe(.Incoming, handler: { (message: Message) -> Void in
      if message.clientId == self.contact.channel {
        var d = JSON(data: message.text.dataUsingEncoding(NSUTF8StringEncoding)!)
        var drawingJson =  DrawingJson(json: d)
        dispatch_async(dispatch_get_main_queue(), {
          var drawing = drawingJson.toDrawing()
          self.messageController.addDrawing(drawing)
        })
      }
    })
  }

}
