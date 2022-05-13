//
//  ViewController.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-12.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    let signInConfig = GIDConfiguration.init(clientID: "309480249220-eer5pd7v43ik160ldhml2f2rn2b8i9oc.apps.googleusercontent.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.style = GIDSignInButtonStyle.standard
        signInButton.colorScheme = GIDSignInButtonColorScheme.light
    }

    @IBOutlet var signInButton: GIDSignInButton!
    
    @IBAction func signInTap(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          guard error == nil else { return }
          print("Done")
          // If sign in succeeded, display the app's main content View.
        }
    }
}
