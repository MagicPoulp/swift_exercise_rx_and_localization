//
//  ContactsTableViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-14.
//

import UIKit
import Contacts
import Combine

class ContactsTableViewController: UITableViewController {
    var subscriptions = Set<AnyCancellable>()
    var contacts = [FetchedContact]()
    var viewModel = ContactsTableViewModel()
    let mapSortingStateToKey = [ContactsSortingState.byFirstname: "firstname", ContactsSortingState.byLastname: "lastname"]

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()

        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(onSortContacts),
                         name: NSNotification.Name("sortContacts"),
                         object: nil)

        fetchContacts()
    }
    
    func bindViewModel() {
        // binding UI logic publishers to work to be done
        viewModel.activeContactsSortingState
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { val in
                let sortingKey = self.mapSortingStateToKey[val]
                // the revert sort allows additional tapping to sort in reverse order
                if (self.viewModel.previousContactsSortingState == val) {
                    self.viewModel.sortingMultiplier *= -1
                } else {
                    self.viewModel.sortingMultiplier = 1
                }
                let reverserSort = self.viewModel.sortingMultiplier == -1
                self.contacts.sort(by: { contactStruct1, contactStruct2 in
                    let contact1 = contactStruct1.asDictionary
                    let contact2 = contactStruct2.asDictionary
                    if (reverserSort) {
                        return (contact1[sortingKey ?? "firstname"] as! String) > (contact2[sortingKey ?? "firstname"] as! String)
                    }
                    return (contact1[sortingKey ?? "firstname"] as! String) < (contact2[sortingKey ?? "firstname"] as! String)
                })
                self.tableView.reloadData()
                self.viewModel.previousContactsSortingState = val
            }
            .store(in: &subscriptions)
    }

    @objc func onSortContacts(notif: NSNotification) {
        guard let userInfo = notif.userInfo else {
            return
        }
        viewModel.activeContactsSortingState.value = userInfo["activeContactsSortingState"] as! ContactsSortingState
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
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
