//
//  ProfileHeaderViewModel.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/09.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String{
        return user.fullname
    }
    
    var profileImageUrl: URL?{
        return URL(string: user.profileImageURL)
    }
    
    var followButtonText: String{
        if user.isCurrentUser{
            return "프로필 수정"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    var followButtonBackgroundColor: UIColor{
        return user.isCurrentUser ? .white : .systemBlue
    }
    var followButtonTextColor: UIColor{
        return user.isCurrentUser ? .black : .white
    }
    var numberOfFollowers: NSAttributedString{
        return attributedStatText(value: user.stats.followers, label: "followers")
    }
    var numberOfFollwing: NSAttributedString{
        return attributedStatText(value: user.stats.following, label: "following")
    }
    var numberOfPost: NSAttributedString{
        return attributedStatText(value: 5, label: "post")
    }
    init(user: User){
        self.user = user
    }
    func attributedStatText(value: Int, label: String) -> NSAttributedString{
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
}
