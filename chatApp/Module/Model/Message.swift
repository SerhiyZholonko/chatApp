//
//  Message.swift
//  chatApp
//
//  Created by apple on 14.09.2023.
//

import Foundation
import Firebase

struct Message {
    let text: String
    let fromID: String
    let toID: String
    let timestamp: Timestamp
    let username: String
    let fullName: String
    let profileImageURL: String
    var isFromCurrentUser: Bool
    var chatPartnerID: String {return isFromCurrentUser ? toID : fromID}
    let newMessage: Int
    let imageUrl: String
    let videoUrl: String
    let audioUrl: String
    let locationUrl: String
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.username = dictionary["username"] as? String ?? ""
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.isFromCurrentUser = Auth.auth().currentUser?.uid == fromID
        self.newMessage = dictionary["new_message"] as? Int ?? 0
        self.imageUrl = dictionary["imageURL"] as? String ?? ""
        self.videoUrl = dictionary["videoURL"] as? String ?? ""
        self.audioUrl = dictionary["audioURL"] as? String ?? ""
        self.locationUrl = dictionary["locationURL"] as? String ?? ""
    }

}
