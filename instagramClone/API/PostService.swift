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
            let docRef = COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
            self.updateUserFeedAfterPost(postId: docRef.documentID)
            
            
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
            posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds})
            completion(posts)
        }
        
    }
    static func fetchPosts(withPostId postId: String, completion: @escaping(Post)-> Void){
        COLLECTION_POSTS.document(postId).getDocument{ snapshot, _ in
            guard let snapshot = snapshot else {return}
            guard let data = snapshot.data() else {return}
            let post = Post(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes":post.likes+1])
        //게시물 아이디에 post-likes라는 콜렉션 만들고 거기에 uid(라이크를 누른 계정)을 추가한다
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:],completion: completion)//현재 접속한 유저데이터에 user-likes라는 콜렉션만들고 거기에 게시물 아이디를 적어놓는다.
        }
        
    }
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        guard post.likes > 0 else {return}
        COLLECTION_POSTS.document(post.postId).updateData(["likes":post.likes-1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete() {_ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    static func checkIfUserLikedPost(post: Post, completion:@escaping(Bool)->Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { (snapshot, _) in
            guard let didLike = snapshot?.exists else {return}
            completion(didLike) //ture = 해당 계정 user-likes에 해당 게시물이 들어있다.
        }
        
    }
    static func fetchFeedPosts(completion: @escaping([Post])->Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        var posts = [Post]()
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            snapshot?.documents.forEach{ document in
                fetchPosts(withPostId: document.documentID) { post in
                    posts.append(post)
                    posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds})
                    completion(posts)
                }
            }
        }
    }
    static func updateUserFeedAfterFollowing(user: User, didFollow: Bool){
        guard let uid = Auth.auth().currentUser?.uid else{ return}
        
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user.uid)
        //프로필에 들어가(팔로우)누른 user.uid가 작성한 글들을 ownerUid로 찾아서 그 포스트의 각 도큐먼트 아이디를 접속한 유저user-feed에 저장
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            
            let docIDs = documents.map({$0.documentID})
            docIDs.forEach{ id in
                if didFollow {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).setData([:])
                }else{
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).delete()
                }
                
            }
        }
    }
    static func updateUserFeedAfterPost(postId: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot,_ in
            guard let documents = snapshot?.documents else {return} //해당 유저를 팔로우하고있는사람들
            
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            COLLECTION_USERS.document(uid).collection("user-feed").document(postId).setData([:])
        }
    }
}
