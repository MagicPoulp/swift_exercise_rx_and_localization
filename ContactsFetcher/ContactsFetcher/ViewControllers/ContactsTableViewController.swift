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
        // this is known for not blocking the UI main thread
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
                        self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, email: String(contact.emailAddresses.first?.value ?? "")))
                    })
                    print(self.contacts)
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // 1.
        // return the number of sections
        return 1
    }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2.
        // return the number of rows
        return contacts.count
    }

  /*
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // 3.
        // Configure the cell...
        cell.textLabel?.text = contacts[indexPath.row].firstName + " " + contacts[indexPath.row].lastName
        cell.detailTextLabel?.text = contacts[indexPath.row].telephone
        return cell
    }
   */
}
