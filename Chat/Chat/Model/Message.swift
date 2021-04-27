//
//  Message.swift
//  Chat
//
//  Created by Megha Bhattad on 4/22/21.
//

import Foundation
import  Firebase

struct  Message {
    let text: String
    let toId: String
    let fromId: String
    var timestamp: Timestamp
    var user: User?
    let isFromCurrentUser: Bool
    var chatPartnerId: String {
        return isFromCurrentUser ? toId :fromId
    }
    
    init(dicitionary:[String:Any]) {
        self.text = dicitionary["text"] as? String ?? ""
        self.toId = dicitionary["toId"] as? String ?? ""
        self.fromId = dicitionary["fromId"] as? String ?? ""
        self.timestamp = dicitionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    let  user: User
    let message: Message
}
