//
//  File.swift
//  chatApp
//
//  Created by apple on 10.09.2023.
//

import Foundation

struct User{
    let email: String
    let username: String
    let fullname: String
    let uid: String
    let profileImageURL: String
    
    init (dictionary: [String: Any]){
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}
