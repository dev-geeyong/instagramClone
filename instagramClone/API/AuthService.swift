//
//  AuthService.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/09.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}
struct AuthService {
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }//id password 확인
    
    static func registerUser(withCredential credentials: AuthCredentials, complietion: @escaping(Error?)->Void){
        
        ImageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password){
                (result, error) in
                if let error = error {
                    print("debug failed to register user \(error.localizedDescription)")
                }
                
                guard let uid = result?.user.uid else{return}
                
                let data: [String: Any] = ["email": credentials.email,
                                           "fullname" : credentials.fullname,
                                           "username": credentials.username,
                                           "uid": uid,
                                           "profileImageURL": imageURL]
                COLLECTION_USERS.document(uid).setData(data, completion: complietion)
                
            }
        }
        
    }
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?){
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
