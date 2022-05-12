//
//  ViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-12.
//

import UIKit
import GoogleSignIn

//let signInConfig = GIDConfiguration.init(clientID: "309480249220-eer5pd7v43ik160ldhml2f2rn2b8i9oc.apps.googleusercontent.com")

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.style = GIDSignInButtonStyle.standard
        signInButton.colorScheme = GIDSignInButtonColorScheme.light
    }

    @IBOutlet var signInButton: GIDSignInButton!
    
}

