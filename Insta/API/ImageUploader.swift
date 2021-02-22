//
//  ImageUploader.swift
//  Insta
//
//  Created by AriChou on 2/4/21.
//

import Foundation
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference(withPath: "profile_image/\(fileName)")
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("存储用户头像失败", error.localizedDescription)
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
