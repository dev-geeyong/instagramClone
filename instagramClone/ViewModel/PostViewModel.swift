//
//  PostViewModel.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import Foundation

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
    init(post: Post){
        self.post = post
    }
}

