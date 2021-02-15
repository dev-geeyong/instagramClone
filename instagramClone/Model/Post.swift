//
//  Post.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import Foundation
import Firebase

struct Post {
    var caption: String
    var likes: Int
    let imageURL: String
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String
    let ownerImageUrl: String
    let ownerUsername: String
    
    init(postId: String, dictionary: [String: Any]){
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        
    }
}
