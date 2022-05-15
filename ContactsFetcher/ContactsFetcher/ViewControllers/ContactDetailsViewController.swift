//
//  ContactDetailsViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-15.
//


import UIKit

class ContactDetailsViewController: UIViewController {
    
    var contact: FetchedContact = FetchedContact()

    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    @IBOutlet var fullnameTitle: UILabel!
    @IBOutlet var emailTitle: UILabel!

    @IBOutlet var stackView1: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        fullnameLabel.text = contact.firstname + " " + contact.lastname
        emailLabel.text = contact.email

        fullnameTitle.text = "NAME".localized()
        emailTitle.text = "EMAIL".localized()
        let fontSize = 14.0
        fullnameTitle.font = UIFont(name:"HelveticaNeue-Bold", size: fontSize)
        emailTitle.font = UIFont(name:"HelveticaNeue-Bold", size: fontSize)
        fullnameLabel.font = UIFont.systemFont(ofSize: fontSize)
        emailLabel.font = UIFont.systemFont(ofSize: fontSize)

        stackView1.setCustomSpacing(20, after: fullnameLabel)
    }
}
