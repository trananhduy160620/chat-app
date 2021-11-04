//
//  Message.swift
//  ChatApp
//
//  Created by duytran on 10/26/21.
//

import Foundation
import FirebaseAuth

struct User {
    let id:String
    let displayName:String
    let email:String
}
struct Message {
    //let messageID:String
    let content:String
    let receiver:String
    let sender:String
    func chatWithPartner() -> String {
        return sender == Auth.auth().currentUser?.uid ? receiver : sender
    }
}
/*
struct User {
 let id:String
 let displayName:String
 let email:String
}
 struct MessageTest {
 let content:String
 let sender:User
 let receiver:User
 let roomID:String
 }
*/
