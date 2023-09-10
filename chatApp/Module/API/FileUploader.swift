//
//  FileUploader.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage


struct FileUploader {
    static func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let uid = Auth.auth().currentUser?.uid ?? "/profileImages/"
        let filename = NSUUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/\(uid)/\(filename)")
        
        ref.putData(imageData) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
            }
            ref.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let fileUrl = url?.absoluteString else { return }
                completion(fileUrl)
            }
        }
    }
    static func getImage (withImageURL imageURL: URL, completion: @escaping (UIImage) -> Void){
        SDWebImageManager.shared.loadImage(with: imageURL, options: .continueInBackground, progress: nil) { image, data, error, cashType, finised, url in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let image = image else {return}
            completion(image)
        }
        
    }
}
