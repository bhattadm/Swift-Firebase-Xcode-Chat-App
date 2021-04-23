//
//  ConversationViewModel.swift
//  Chat
//
//  Created by Megha Bhattad on 4/22/21.
//

import Foundation

struct ConversationViewModel {
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
