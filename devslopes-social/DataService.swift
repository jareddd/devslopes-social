//
//  DataService.swift
//  devslopes-social
//
//  Created by jareddd on 5/23/17.
//  Copyright © 2017 jetfuel. All rights reserved.
//

import Foundation
import Firebase//they are split out into different structures Firebase imports them all

//other modules auth core storage database analytics etc.

let DB_BASE = FIRDatabase.database().reference()
//this contains the URL of the root of the database
//this information is found in the GoogleService-info.plist - its there as this variable

//reference to the images on firebase - pulling in from the firebase pod 'Firebase/Storage'
let STORAGE_BASE = FIRStorage.storage().reference()


class DataService {
    //referencing the end points to the database
    //common end points
    
    static let ds = DataService()
    //static - global - everyone can access this one 
    //singleton
    
    //common end points
    
    //everything is globally accessible
    // DB references
    private var _REF_BASE = DB_BASE //root of the db
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage References
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirebaseUser(uid: String, userData: Dictionary<String, String>) {
        // within Firebase, if it is not there, it will create it - by default
        REF_USERS.child(uid).updateChildValues(userData)
        //adding the UID as the value of the child, then creates the data dictionary to the child of that
        // there is an option to setvalue() this wipes out data
    }
    
    
    
    
    
}
