//
//  MessageService.swift
//  chatApp
//
//  Created by apple on 14.09.2023.
//

import UIKit
import Firebase

struct MessageService {
  
    static func fetchRecentMessages(completion: @escaping ([Message]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = Constants.CollectionMessage.document(uid).collection("recent-message").order(by: "timestamp")
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let documentChanges = snapshot?.documentChanges else { return }
            let messages = documentChanges.map({Message(dictionary: $0.document.data())})
            completion(messages)
        }
    }
    static func uploadMessage(message: String = "", imageUrl: String = "", videoUrl: String = "", audioUrl: String = "", locationUrl: String = "", currentUser: User, unReadCounter: Int, otherUser: User, completion: ((Error?) -> Void)?) {
        let dataFrom: [String: Any] = ["text": message,
                                       "fromID": currentUser.uid,
                                       "toID": otherUser.uid,
                                       "timestamp": Timestamp (date: Date()),
                                       "username": otherUser.username, "fullname": otherUser.fullname,
                                       "profileImageURL": otherUser.profileImageURL,
                                       "new_message": 0,
                                       "imageURL": imageUrl,
                                       "videoURL": videoUrl,
                                       "audioURL": audioUrl,
                                       "locationURL": locationUrl]
      
        
        
        let dataTo: [String: Any] = [
            "text": message,
            "fromID": currentUser.uid,
            "toID": otherUser.uid,
            "timestamp": Timestamp (date: Date()),
            "username": currentUser.username,
            "fullname": currentUser.fullname,
            "profileImageURL": currentUser.profileImageURL,
            "new_message": unReadCounter,
            "imageURL": imageUrl,
            "videoURL": videoUrl,
            "audioURL": audioUrl,
            "locationURL": locationUrl]
       

        
        Constants.CollectionMessage.document(currentUser.uid).collection(otherUser.uid).addDocument(data: dataFrom) { _ in
            Constants.CollectionMessage.document(otherUser.uid).collection(currentUser.uid).addDocument(data: dataTo, completion: completion)
            Constants.CollectionMessage.document(currentUser.uid).collection("recent-message").document(otherUser.uid).setData(dataFrom)
            Constants.CollectionMessage.document(otherUser.uid).collection("recent-message").document(currentUser.uid).setData(dataTo)
        }
    }
    
    static func fetchMessages(otherUser: User, completion: @escaping (([Message]) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var messages = [Message]()
         
        let query = Constants.CollectionMessage.document(uid).collection(otherUser.uid).order(by: "timestamp", descending: true)
        query.addSnapshotListener { snapshot, error in
            guard let documentChange = snapshot?.documentChanges.filter({$0.type == .added}) else { return }
             messages.append(contentsOf: documentChange.map{Message(dictionary: $0.document.data())})
            completion(messages)
        }
    }
    static func fetchSingleResentMessage(otherUser: User,  complition: @escaping(Int) -> Void ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Constants.CollectionMessage.document(otherUser.uid).collection("recent-message").document(uid).getDocument { snashot, _ in
            guard let data = snashot?.data() else {
                complition(0)
                return }
            let message = Message(dictionary: data)
            complition(message.newMessage)
            
        }
    }
    static func markReadAllMessage(otherUser: User) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = [
            "new_message": 0
        ]
        Constants.CollectionMessage.document(uid).collection("recent-message").document(otherUser.uid).updateData(data)
    }
}
