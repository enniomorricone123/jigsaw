//
//  Message.swift
//  Jigsaw
//
//  Created by student on 11/10/19.
//  Copyright © 2019 ECE564. All rights reserved.
//



import UIKit

class Message: NSObject {

    var fromId: String?
    var text: String?
    var name: String?
    var timestamp: NSNumber?
    var group:  Int?
    var toId: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.name = dictionary["name"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.group =  dictionary["group"] as? Int

    }
    
}
