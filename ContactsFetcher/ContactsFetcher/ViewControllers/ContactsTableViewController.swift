//
//  ContactsTableViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-14.
//

import UIKit
import Contacts

class ContactsTableViewController: UITableViewController {
    
    var contacts = [FetchedContact]()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchContacts()
    }

    // https://developer.apple.com/documentation/contacts/cncontactstore/1402873-requestaccess
    // https://www.ioscreator.com/tutorials/fetch-contacts-ios-tutorial
    private func fetchContacts() {
        // 1.
        let store = CNContactStore()
        // this async and not blocking the UI main thread
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(FetchedContact(firstname: contact.givenName, lastname: contact.familyName, email: String(contact.emailAddresses.first?.value ?? "")))
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2.
        // return the number of rows
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as! ContactsCell
        // 3.
        // Configure the cell...
        cell.firstnameLabel?.text = contacts[indexPath.row].firstname
        cell.lastnameLabel?.text = contacts[indexPath.row].lastname
        return cell
    }
}

// the recommended way to communicate between 2 view controllers repeatedly lies in
// the NotificationCenter
// https://stackoverflow.com/questions/32437094/pass-data-to-the-container-view-in-swift
