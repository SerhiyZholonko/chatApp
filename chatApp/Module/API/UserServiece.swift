//
//  UserServiece.swift
//  chatApp
//
//  Created by apple on 10.09.2023.
//

import Foundation


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
}
