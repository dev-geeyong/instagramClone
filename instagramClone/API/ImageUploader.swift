//
//  ImageUploader.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/09.
//

import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String)->Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil){ metadata, error in
            if let error = error {
                print("debug failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL{( url, error) in
                guard let imageURL = url?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
}
