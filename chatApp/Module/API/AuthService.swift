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
                    complition(error)
                    return
                }
                guard let uid = result?.user.uid else { return }
                let data = [
                    "email": creadtional.email,
                    "username": creadtional.username,
                    "fullname": creadtional.fullname,
                    "uid": uid,
                    "profileImageURL": stringURL
                ]
                Constants.CollectionUsers.document(uid).setData(data, completion: complition )
            }
        }
    }
    static func loginUser(withEmail email: String, withPassword password: String, completion: @escaping ( AuthDataResult?,  Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    static func signOut(completion: @escaping (Error?) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    static func signUpInGoogle(username: String, email: String, fullname: String, image: UIImage, uid: String, completion: @escaping (Error?) -> Void) {
        FileUploader.uploadImage(image: image) { stringURL in
            let data = [
                "email": email,
                "username": username,
                "fullname": fullname,
                "uid": uid,
                "profileImageURL": stringURL
            ]
            Constants.CollectionUsers.document(uid).setData(data) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
        
        
    }
}


struct AuthCreadtion{
    let email: String
    let password: String
    let username: String
    let fullname: String
    let profileImage: UIImage
}
