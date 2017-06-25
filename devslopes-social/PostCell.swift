//
//  PostCell.swift
//  devslopes-social
//
//  Created by jareddd on 5/20/17.
//  Copyright © 2017 jetfuel. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    //var of type post needed
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //configure the cell - pass a post in
    //img is an optional because it may not be there
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)" //syntax sugar
        
        //images for the post
        if img != nil {
            //if the image is in cache use it
            self.postImg.image = img
        } else {
            //if the image is not in cache, go get it
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 10 * 1024 * 1024, completion: {(data,Error) in
                //try and bring down the image from the url
                if Error != nil {
                    print("JARED: unable to download image from Firebase storage")
                } else {
                    print("JARED: Image downloaded from Firebase Storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            }) // calculation for storage
        }
    }
    

}
