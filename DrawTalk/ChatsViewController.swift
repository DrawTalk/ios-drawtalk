//
//  ChatsViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/22/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

class ChatsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
  
  private var chats = [Chat]()
  
  var filteredChats = [Chat]()
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    self.chats = []
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  class func controller() -> ChatsViewController {
    let vc = ChatsViewController(nibName:"ChatsViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    loadChats()
  }

  private func loadChats() {
    var allChats = ChatDataProvider.fetchAllChats()
  }
  
  private func setupNavigationBar() {
    
    let navigationItemTitle = DWTLocalizedStringWithDefaultValue(
      "screen.chats.navigation-bar.title",
      tableName: "Localizable",
      bundle: NSBundle.mainBundle(),
      value: "Chats",
      comment: "Title for chats' screen")
    
    navigationItem.title = navigationItemTitle
  }

  func filterContentForSearchText(searchText: String) {
    /*
    filteredChats = chats.filter({( contact : Contact) -> Bool in
      var stringMatch = contact.firstName?.rangeOfString(searchText)
      return stringMatch != nil
    })
    */
  }
  
  func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
    self.filterContentForSearchText(searchString)
    return true
  }
}

extension ChatsViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  }
}

extension ChatsViewController: UITableViewDataSource {
  func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
    if tableView == self.searchDisplayController!.searchResultsTableView {
      return []
    } else {
      return collation.sectionIndexTitles
    }
  }
  
  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    if tableView == self.searchDisplayController!.searchResultsTableView {
      return 1
    } else {
      return collation.sectionForSectionIndexTitleAtIndex(index)
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.searchDisplayController!.searchResultsTableView {
      return filteredChats.count
    } else {
      return chats.count
    }
  }
  
  func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    return ""
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let kCellIdentifier = "ChatCellIndentifier"
    var cell = self.tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
    }
    
    var chat : Chat
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if tableView == self.searchDisplayController!.searchResultsTableView {
      chat = filteredChats[indexPath.row]
    } else {
      chat = chats[indexPath.row]
    }
    
    // Configure the cell
    cell!.textLabel.text = ""
    cell!.detailTextLabel?.text = ""
    cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    return cell!
  }
}
