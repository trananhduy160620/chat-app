//
//  FirebaseChatManager.swift
//  ChatApp
//
//  Created by duytran on 11/5/21.
//

import UIKit
import Firebase
import FirebaseAuth

class FirebaseChatManager {
    static var shared = FirebaseChatManager()
    private var ref : DatabaseReference!
    private init() {
        ref = Database.database().reference()
    }
    
    public func fetchChat(currentUserID:String, with userID:String, completion: @escaping((Result<[Message],Error>) -> Void)) {
        let conversationNode = ref.child("Conversation").child("Messages")
        conversationNode.observe(.value, with: { (snapshot) in
            var tempMessages:[Message] = []
            for child in snapshot.children {
                let messSnapShot = child as! DataSnapshot
                let messageDict = messSnapShot.value as! [String:Any]
                let sender = messageDict["sender"] as! String
                let content = messageDict["content"] as! String
                let receiver = messageDict["receiver"] as! String
                if (receiver == userID && sender == currentUserID) || (receiver == currentUserID && sender == userID)
                {
                    let message = Message(content: content, receiverID: receiver, senderID: sender)
                    tempMessages.append(message)
                }
            }
            completion(.success(tempMessages))
        }, withCancel: nil)
    }
    
    public func addChat(message:Message, completion: @escaping((Result<DatabaseReference, Error>) -> Void)) {
        let rootNode = ref.child("Conversation").child("Messages")
        let value = ["content": message.content, "receiver": message.receiverID, "sender": message.senderID]
        rootNode.childByAutoId().setValue(value) { (error, databaseRef) in
            if let error = error as Error? {
                completion(.failure(error))
            } else {
                completion(.success(databaseRef))
            }
        }
    }
}
