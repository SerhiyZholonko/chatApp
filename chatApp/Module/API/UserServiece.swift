//
//  UserServiece.swift
//  chatApp
//
//  Created by apple on 10.09.2023.
//

import Foundation
import Firebase

struct UserServiece{
    static func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        Constants.CollectionUsers.document(uid).getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    static func fetchUsers(complition: @escaping ([User]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Constants.CollectionUsers.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var users = [User]()
            guard let snapshot = snapshot else { return }
            for snap in snapshot.documents {
                let dictionady = snap.data()
                let user = User(dictionary: dictionady)
                if user.uid != uid {
                    users.append(user)
                }
            }
            complition(users)
        }
    }
}
