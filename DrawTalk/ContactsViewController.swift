//
//  ContactsViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/12/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

struct Candy {
  let category : String
  let name : String
}

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var contacts = [Contact]()
  var filteredContacts = [Contact]()
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  class func controller() -> ContactsViewController {
    let vc = ContactsViewController(nibName:"ContactsViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    // Sample Data for candyArray
    super.viewDidLoad()

    setupNavigationBar()
    retrieveContactsFromAddressBook()
  }
  
  private func setupNavigationBar() {
    let navigationItemTitle = DWTLocalizedStringWithDefaultValue(
      "screen.contacts.navigation-bar.title",
      tableName: "Localizable",
      bundle: NSBundle.mainBundle(),
      value: "Contacts",
      comment: "Title for contacts' screen")
    
    navigationItem.title = navigationItemTitle
  }
  
  private func retrieveContactsFromAddressBook() {
    AddressBookImport.defaultAddressBookImport.contacts { (contacts: [Contact]?, error: NSError?) in
      dispatch_async(dispatch_get_main_queue(), {
        self.contacts = contacts!
        self.tableView.reloadData()
      })
    }
  }
  
  /*
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
  }
  */
  
  /*
  func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
    
  }
  func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
  }
  */

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.searchDisplayController!.searchResultsTableView {
      return filteredContacts.count
    } else {
      return contacts.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let kCellIdentifier = "ContactsCellIndentifier"
    var cell = self.tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
    }
    
    var contact : Contact
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if tableView == self.searchDisplayController!.searchResultsTableView {
      contact = filteredContacts[indexPath.row]
    } else {
      contact = contacts[indexPath.row]
    }
    
    // Configure the cell
    cell!.textLabel.text = contact.firstName
    cell!.detailTextLabel?.text = "I'm on DrawTalk"
    cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    return cell!
  }
  
  func filterContentForSearchText(searchText: String) {
    filteredContacts = contacts.filter({( contact : Contact) -> Bool in
      var stringMatch = contact.firstName?.rangeOfString(searchText)
      return stringMatch != nil
    })
  }
  
  func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
    self.filterContentForSearchText(searchString)
    return true
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let ctrl = ConversationViewController.controller(channel: "6504047096")
    ctrl.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(ctrl, animated: true)
  }
}