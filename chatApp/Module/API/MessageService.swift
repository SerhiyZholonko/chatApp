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
    static func uploadMessage (message: String, currentUser: User,
                               otherUser: User, completion: ((Error?) -> Void)?) {
        let dataFrom: [String: Any] = ["text": message,
                                       "fromID": currentUser.uid,
                                       "toID": otherUser.uid,
                                       "timestamp": Timestamp (date: Date()),
                                       "username": otherUser.username, "fullname": otherUser.fullname,
                                       "profileImageURL": otherUser.profileImageURL]
        
        
        let dataTo: [String: Any] = [
            "text": message,
            "fromID": currentUser.uid,
            "toID": otherUser.uid,
            "timestamp": Timestamp (date: Date()),
            "username": currentUser.username,
            "fullname": currentUser.fullname,
            "profileImageURL": currentUser.profileImageURL]
        
        Constants.CollectionMessage.document(currentUser.uid).collection(otherUser.uid).addDocument(data: dataFrom) { _ in
            Constants.CollectionMessage.document(otherUser.uid).collection(currentUser.uid).addDocument(data: dataTo, completion: completion)
            Constants.CollectionMessage.document(currentUser.uid).collection("recent-message").document(otherUser.uid).setData(dataFrom)
        }
    }
    
    static func fetchMessages(otherUser: User, completion: @escaping (([Message]) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var messages = [Message]()
         
        let query = Constants.CollectionMessage.document(uid).collection(otherUser.uid).order(by: "timestamp")
        query.addSnapshotListener { snapshot, error in
            guard let documentChange = snapshot?.documentChanges.filter({$0.type == .added}) else { return }
             messages.append(contentsOf: documentChange.map{Message(dictionary: $0.document.data())})
            completion(messages)
        }
    }
}
