//
//  ContactsViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/12/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

extension String {
  subscript (i: Int) -> String {
    return String(Array(self)[i])
  }
}

protocol Item {
  var section: Int? { get }
  var localizedTitle: String { get }
}

class Section<T> {
  var items: [T] = []
  func addItem(item: T) {
    self.items.append(item)
  }
}

class ContactItem: NSObject, Item {
  let contact: Contact
  var section: Int?
  var localizedTitle: String
  
  init(contact: Contact) {
    self.contact = contact
    self.localizedTitle = contact.firstName![0]
  }
}

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var sections = [Section<ContactItem>]()
  private var contacts: [Contact] {
    didSet {
      let selector: Selector = "localizedTitle"

      // create items from the contacts list
      var items: [ContactItem] = contacts.map { contact in
        var item = ContactItem(contact: contact)
        item.section = self.collation.sectionForObject(item, collationStringSelector: selector)
        return item
      }
      
      
      // create empty sections
      var sections = [Section<ContactItem>]()
      for i in 0..<self.collation.sectionIndexTitles.count {
        sections.append(Section())
      }
      
      // put each item in a section
      for item in items {
        sections[item.section!].addItem(item)
      }
      
      // sort each section
      for section in sections {
        section.items = self.collation.sortedArrayFromArray(section.items, collationStringSelector: selector) as [ContactItem]
      }
      
      self.sections = sections;
    }
  }
  
  var filteredContacts = [Contact]()

  let collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation

  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    self.contacts = []
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
        let contactsTokenDecorator = ContactsTokenDecorator(self.contacts)
        contactsTokenDecorator.decorate({ (success, error) -> Void in
          if success {
            self.tableView.reloadData()
          }
        })
      })
    }
  }
  
  func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
    if tableView != self.searchDisplayController!.searchResultsTableView {
      // do not display empty `Section`s
      if !self.sections[section].items.isEmpty {
        return self.collation.sectionTitles[section] as String
      }
    }
    return ""
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if tableView == self.searchDisplayController!.searchResultsTableView {
      return 1
    } else {
      return self.sections.count
    }
  }

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

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.searchDisplayController!.searchResultsTableView {
      return filteredContacts.count
    } else {
      return sections[section].items.count
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
      let item = sections[indexPath.section].items[indexPath.row]
      contact = item.contact
    }
    
    // Configure the cell
    cell!.textLabel.text = contact.firstName
    if contact.token != nil {
      cell!.detailTextLabel?.text = "I'm on DrawTalk"
    }
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
    var selectedContact: Contact
    if tableView == self.searchDisplayController!.searchResultsTableView {
      selectedContact = filteredContacts[indexPath.item]
    } else {
      selectedContact = sections[indexPath.section].items[indexPath.row].contact
    }

    let ctrl = ConversationViewController.controller(channel: AppSession.mainSession.currentUser!.userKey!, contact: selectedContact)
    ctrl.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(ctrl, animated: true)
  }
}