//
//  AuthService.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit
import Firebase

struct AuthService {
    
    static func registerUser(creadtional: AuthCreadtion, complition: @escaping (Error?) -> Void) {
        FileUploader.uploadImage(image: creadtional.profileImage) { stringURL in
            Auth.auth().createUser(withEmail: creadtional.email, password: creadtional.password) { result, error  in
                if let error = error {
                    print("Error create account ", error.localizedDescription)
                }
                guard let uid = result?.user.uid else { return }
                let data = [
                    "email": creadtional.email,
                    "username": creadtional.username,
                    "fullname": creadtional.fullname,
                    "profileImageURL": stringURL
                ]
                Constants.CollectionUsers.document(uid).setData(data, completion: complition )
            }
        }
    }
    static func loginUser() {
        
    }
}


struct AuthCreadtion{
    let email: String
    let password: String
    let username: String
    let fullname: String
    let profileImage: UIImage
}
