//
//  game.swift
//  Jigsaw
//
//  Created by Mengqian Liu on 11/29/19.
//  Copyright © 2019 ECE564. All rights reserved.
//
import UIKit
import Firebase

public class game{
    var resource: String
    var questions: [String]
    var answers: [[String]]
   
    
    init(){
        self.resource = ""
        self.questions = [String]()
        self.answers = [[String]()]
    }
    
   init(dictionary: NSDictionary){
    self.resource = dictionary["resource"] as! String
    self.questions = dictionary["questions"] as! [String]
    self.answers=dictionary["answers"] as! [[String]]
       }
    
  init(resource:String,questions: [String],answers: [[String]]){
    self.resource = resource
    self.questions = questions
    self.answers = answers

}

}


