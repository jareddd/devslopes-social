//
//  ViewController.swift
//  devslopes-social
//
//  Created by jareddd on 4/20/17.
//  Copyright © 2017 jetfuel. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //save uid to the keychain to ensure auto login when opening from idle or delete and login
        //dont need to return anything
        //cannot perform seques in viewdidload because the segue doesn't exist
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("JARED: already signed in, moving to Feed")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        //test to see if you're logged in and go to the next page
        
        
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        //2 steps
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JARED: Unable to authenticate with Facebook")
            } else if (result?.isCancelled)! {
                print("JARED: User cancled Facebook authentication")
            } else {
                print("JARED: Successfully authenticated with Facebook")
                //attempt authentication with Facebook
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //attempt authentication with firebase via method below
                self.firebaseAuth(credential)
            }
            
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        //attempt authorization with Firebase
        FIRAuth.auth()?.signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print("JARED: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("JARED: Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
                
            }
        })
    }

    @IBAction func signinTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    //user exists and the password is good
                    //print("JARED: Email user authenticated with Firebase, Hurray")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    print("JARED: (before cre user) user and password: \(email) and \(pwd)")
                    //error user was not able to authenticate
                    print("JARED: Email user did not authenticate \(String(describing: error))")
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        print("JARED: (just after attempt to cre user) user and password: \(email) and \(pwd)")
                        if error != nil {
                            print("JARED: Unable to authenticate with Firebase using email")
                        } else {
                            print("JARED: Successfully authenticated with Firebase: email user")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JARED: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

