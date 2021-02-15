//
//  PostService.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import UIKit
import Firebase

struct PostService {
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        ImageUploader.uploadImage(image: image){ imageUrl in
            let data = ["caption" : caption ,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageURL": imageUrl,
                        "ownerImageUrl" : user.profileImageURL,
                        "ownerUsername" : user.username,
                        "ownerUid": uid] as [String:Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
        }
        
    }
    static func fetchPosts(completion: @escaping([Post])->Void){
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments {(snapshot, error) in
            guard let documents = snapshot?.documents else{return}
            
            let posts = documents.map({Post(postId: $0.documentID, dictionary: $0.data())})
            completion(posts)
        }
    }
    static func fetchPosts(forUser uid: String, completion: @escaping([Post])->Void){
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else{return}
            
            var posts = documents.map({Post(postId: $0.documentID, dictionary: $0.data())})
            posts.sort{ ( post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            completion(posts)
        }
        
    }
}
