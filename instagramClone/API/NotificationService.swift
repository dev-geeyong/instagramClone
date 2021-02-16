//
//  NotificationService.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/16.
//

import Firebase

struct NotificationService {
    static func uploadNotification(toUid uid: String, fromUser user: User, type: NotificationType, post: Post? = nil){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard uid != currentUid else {return} // 알림을 보내는 uid가 받는사람의 uid와 같으면 리턴
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        var data: [String:Any] = ["timestamp":Timestamp(date:Date()),
                                  "uid": user.uid,
                                  "type": type.rawValue,
                                  "id" : docRef.documentID,
                                  "userProfileImageUrl": user.profileImageURL,
                                  "username": user.username]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageURL"] = post.imageURL
            
        }
        
        docRef.setData(data)
    }
    static func fetchNotifications(completion: @escaping([Notification])->Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").getDocuments {
            snapshot, _ in
            guard let documents = snapshot?.documents else{return}
            let notifications = documents.map({Notification(dictionary: $0.data() )})
            completion(notifications)
        }
    }
}
