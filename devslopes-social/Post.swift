//
//  Post.swift
//  devslopes-social
//
//  Created by jareddd on 6/19/17.
//  Copyright © 2017 jetfuel. All rights reserved.
//

import Foundation

class Post{
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String! //post id of post key unique identifier for the post
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    //Need to pass ANY object when pulling info in from the JSON
    init(postKey: String, postData: Dictionary<String, Any>) {
        //convert the data from firebase to this stuff
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {//key value pairs need to match otherwise you won't get anything
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
    }
}
