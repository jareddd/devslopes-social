//
//  FeedVC.swift
//  devslopes-social
//
//  Created by jareddd on 5/7/17.
//  Copyright © 2017 jetfuel. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    
    //array of posts
    var posts = [Post]()
    //image picker
    var imagePicker: UIImagePickerController!//forcefully unwrap
    
    // image cache
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self;
        tableView.dataSource = self;
        // Do any additional setup after loading the view.
        
        //initialize the image picker
        imagePicker = UIImagePickerController()
        
        //allow the user to edit the image before it is imported into the app, crop and sutff
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        
        //reference to the singleton - looking for any .value changes
        //command click on the .value will open to show the values that you can fire events off of e.g. child added etc.
        DataService.ds.REF_POSTS.observe(.value, with: { (FIRDataSnapshot) in
            print(FIRDataSnapshot.value as Any)
            if let snapshot = FIRDataSnapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)//add post to the array of posts
                    }
                }
            }
            print("JARED: qty of posts \(self.posts.count)")
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //test
        let post = posts[indexPath.row]
        print("JARED: \(post.caption)")

        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            // pass in image if it exists in the cache
            
            //check cache
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post) // don't need to pass in nil because it is the default
                return cell
            }
            
//            cell.configureCell(post: post)
//            return cell
            
        } else {
            //this is for safety this should never run
            return PostCell()
        }
        // (removed temp code) return cell tableView.dequeueReusableCell(withIdentifier:  "PostCell") as! PostCell
    }
    
    //this shows the image picker to select an image and then goes away
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //get the image that was selected could be a series of stuff
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            //assign it to our image button
            imageAdd.image = image
        } else {//checking to ensure that we're getting an image - can get all sort of media - array of info
            print("JARED: a valid image was not selected ")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        //NEED TO MAKE SURE THAT YOU LET THE USER KNOW YOU ARE ACCESSING THE INFO update info.plist
    }
    
    //image selector button pressed
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signoutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JARED: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignin", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
