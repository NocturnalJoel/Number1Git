//
//  Profile.swift
//  Number1
//
//  Created by Joël Lacoste-Therrien on 2023-08-13.
//

import Foundation

struct Profile: Hashable, Identifiable, Equatable {
    
    var id:String = ""
    var name: String = ""
    var numberOfVotesProfile: Int = 0
    var listPosition:Int = 0
    var isSelected: Bool = false
    var hasVoted: Bool = false
    var hasVotedForPrompt: Bool = false
    var greenDot: Bool = false
    var votedForMe:[String] = []
    var fcmToken:String = ""
    var profileImageURL:String? = ""
    var comments:[Comment]? = []
}

struct Prompt: Hashable, Identifiable, Equatable {
    
    var id: String = ""
    var content: String = ""
    var promptNumberOfVotes: Int = 0
    var promptListPosition:Int = 0
}

struct HistoryElement: Hashable, Identifiable, Equatable {
    
    var id:String = ""
    var topPerson:String = ""
    var dailyPrompt:String = ""
    var date:String = ""
}

struct Comment: Hashable, Identifiable, Equatable {
    
    var id: String = ""
    var name:String = ""
    var comment:String = ""
    var profileImageURLComment:String? = ""
}


