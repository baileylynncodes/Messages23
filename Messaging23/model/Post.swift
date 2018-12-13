//
//  Post.swift
//  Messaging23
//
//  Created by Karissa McDaris on 12/10/18.
//  Copyright © 2018 Karissa McDaris. All rights reserved.
//

import Foundation


struct Messages: Codable {
    
    let text: String
    let timestamp: TimeInterval
    let username: String
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        
        self.username = username
        self.text = text
        self.timestamp = timestamp
        
    }
}

