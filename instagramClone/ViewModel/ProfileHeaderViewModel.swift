//
//  ProfileHeaderViewModel.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/09.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String{
        return user.fullname
    }
    
    var profileImageUrl: URL?{
        return URL(string: user.profileImageURL)
    }
    
    init(user: User){
        self.user = user
    }
}
