//
//  MessageViewModel.swift
//  chatApp
//
//  Created by apple on 14.09.2023.
//

import UIKit


struct MessageViewModel {
    let message: Message
    
    var messageText: String {
        return message.text
    }
    var messageBacgroungColor: UIColor { return message.isFromCurrentUser ? #colorLiteral(red: 0.4196078431, green: 0.831372549, blue: 0.431372549, alpha: 1) : #colorLiteral(red: 0.9058823529, green: 0.9098039216, blue: 0.9137254902, alpha: 1) }
    var messageColor: UIColor { return message.isFromCurrentUser ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
    var unReadCount: Int {return message.newMessage }
    var showIdHideUnreadLabel: Bool {message.newMessage == 0}
    var rightAnchorActive: Bool {return message.isFromCurrentUser}
    var leftAnchorActive: Bool {return !message.isFromCurrentUser}
    var shouldshowHideProfileImage: Bool {return message.isFromCurrentUser}
    var profileImageURL: URL? {return URL(string: message.profileImageURL)}
    var imageURL: URL? {return URL(string: message.imageUrl)}
    var videoURL: URL? {return URL(string: message.videoUrl)}
    var audioURL: URL? {return URL(string: message.audioUrl)}
    var locationURL: URL? {
        let encodedURL = message.locationUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return URL(string: encodedURL ?? "")
        
    }
    var isImageHide: Bool {return message.imageUrl == ""}
    var isVideoHide: Bool {return message.videoUrl == ""}
    var isAudioHide: Bool {return message.audioUrl == ""}
    var isLocationHide: Bool {return message.locationUrl == ""}

    var isTextHide: Bool { return message.imageUrl != "" }
    var fullName: String {
        return message.fullName
    }
     var timestampString: String?{
    let date = message.timestamp.dateValue()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"
         return dateFormatter.string(from: date)
}

    init(message: Message) {
        self.message = message
    }
}
