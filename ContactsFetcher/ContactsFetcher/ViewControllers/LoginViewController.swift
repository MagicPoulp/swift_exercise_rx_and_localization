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
        
        // The code below removes a console warning "Unbalanced calls to begin/end appearance transitions"
        // In SceneDelegate, we skip the login, if the login is saved, but it can cause this warning
    // https://techstalking.com/solved-unbalanced-calls-to-begin-end-appearance-transitions-for-detailviewcontroller-when-pushing-more-than-one-detail-view-controller/
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
                self.beginAppearanceTransition(false, animated: false)
            }
        }
    }

    @IBOutlet var signInButton: GIDSignInButton!
    
    @IBAction func signInTap(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            // If sign in succeeded, display the app's main content View.
            /*
             A delay is added as a workaround because the sign in view controller is not totally finished with this error.
             "ContactsFetcher[9680:218229] [Presentation] Attempt to present <ContactsFetcher.HomeViewController: 0x141d1cd20> on <SFAuthenticationViewController: 0x14280fa00> (from <SFAuthenticationViewController: 0x14280fa00>) whose view is not in the window hierarchy."
            */
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                self.performSegue(withIdentifier: "showHome", sender: self )
            })
            
            // There are different ways to show the HomeViewController
            // this other method is given as an example
            // however, the documentation recommends using a segue, hence we use a segue
            // https://developer.apple.com/documentation/uikit/view_controllers/showing_and_hiding_view_controllers
            /*
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondVC = storyboard.instantiateViewController(identifier: "HomeViewController")
                self.show(secondVC, sender: self)
            })
            */
        }
    }
}
