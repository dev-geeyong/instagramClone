//
//  Comment.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import Firebase

struct Comment {
    let uid: String
    let username: String
    let profileImageURL: String
    let timestapm: Timestamp
    let commentText: String
    
    init(dictionary:[String:Any]){
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.timestapm = dictionary["timestapm"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictionary["comment"] as? String ?? ""
        
    }
}
