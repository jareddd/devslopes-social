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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
            
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user,error) in
            if error != nil {
                print("JARED: Unable to authenticate with Firebase - \(error)")
            } else {
                print("JARED: Successfully authenticated with Firebase")
            }
        })
    }

}

