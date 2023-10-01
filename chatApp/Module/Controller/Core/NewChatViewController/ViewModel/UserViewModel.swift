//
//  UserViewModel.swift
//  chatApp
//
//  Created by apple on 12.09.2023.
//

import Foundation

import Foundation
struct UserViewModel{
    let user: User
    var fullname: String {return user.fullname}
    var username: String {return user.username}
    var profileImageView: URL?{
        return URL(string: user.profileImageURL)
    }
    init (user: User) {
        self.user = user
    }
}
