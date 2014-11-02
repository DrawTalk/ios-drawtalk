//
//  MessageCollectionViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/30/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class MessageCollectionViewController : UIViewController, UICollectionViewDelegate {
  
  @IBOutlet weak var messageCollectionView: UICollectionView!
  
  private var messageCollectionDataSource: MessageCollectionDataSource!
  
  class func controller() -> MessageCollectionViewController {
    let vc = MessageCollectionViewController(nibName:"MessageCollectionViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMessageCollectionView()
    observerMessagingEvent()
  }
  
  private func observerMessagingEvent() {
    MessageEventBus.defaultBus.subscribe(kMessageEventIncoming, handler: { (event: MessageEvent) -> Void in
      let chatMessage = event as ChatMessage
      var d = JSON(data: chatMessage.text.dataUsingEncoding(NSUTF8StringEncoding)!)
      var drawingJson =  DrawingJson(json: d)
      dispatch_async(dispatch_get_main_queue(), {
        self.messageCollectionDataSource.addDrawing(drawingJson.toDrawing())
        //vc.canvasView.reset()
        //vc.canvasView.replay(drawingJson.toDrawing())
      })
    })
  }
  
  private func setupMessageCollectionView() {
    messageCollectionDataSource = MessageCollectionDataSource(collectionView: messageCollectionView)
    messageCollectionView.dataSource = messageCollectionDataSource;
    messageCollectionDataSource.loadWithMessages([nil])
  }
}