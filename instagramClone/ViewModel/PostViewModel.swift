//
//  PostViewModel.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import UIKit

struct PostViewModel {
   var post: Post
    
    var imageURL: URL?{
        return URL(string: post.imageURL)
    }
    var caption:String{return post.caption}
    var likes:Int{return post.likes}
    var userProfileImageUrl: URL? {return URL(string: post.ownerImageUrl)}
    var username: String {return post.ownerUsername}
    var likeString: String{
        if likes != 1 {
            return "\(likes) likes"
        }else{
            return "\(likes) like"
        }
    }
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    var timestampString: String?{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    init(post: Post){
        self.post = post
    }
}

