//
//  User.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/09.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    let profileImageURL: String
    let username: String
    let uid: String
    
    init(dictionary: [String: Any]){
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        
    }
}
