//
//  ChatMessageCell.swift
//  Jigsaw
//
//  Created by student on 11/13/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase


class ChatMessageCell: UITableViewCell{
    let bubblebackgroundView = UIView()
  let messageLable = UILabel()
    
    var leadingConstraint :  NSLayoutConstraint!
    var trailingConstraint :  NSLayoutConstraint!

    
    var chatMessage : Message!{
        didSet{
            bubblebackgroundView.backgroundColor = chatMessage.fromId == Auth.auth().currentUser!.uid ? .darkGray : .white
             messageLable.textColor =  chatMessage.fromId == Auth.auth().currentUser!.uid ? .white : .black
           
        if chatMessage.fromId == Auth.auth().currentUser!.uid {
                                                  print("income")
                                              
                                                  leadingConstraint.isActive = false
                                                  trailingConstraint.isActive = true
                                   
                                              }
                                             
                                              else{
                                                 leadingConstraint.isActive = true
                                                 trailingConstraint.isActive = false
                                                  }
                      
          
    }

    }
  
             //   trailingConstraint.isActive = false
    /*
    var isIncoming = Bool() {
        didSet{
            bubblebackgroundView.backgroundColor = isIncoming ? .darkGray : .white
            messageLable.textColor =  isIncoming ? .white : .black
             

/*
            if isIncoming {
                                  print("income")
                              
                                  leadingConstraint.isActive = false
                                  trailingConstraint.isActive = true
                   
                              }
                             
                              else{
                                 leadingConstraint.isActive = true
                                 trailingConstraint.isActive = false
                                  }
             */
            }
 
    }
    */

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        bubblebackgroundView.backgroundColor = .yellow
        bubblebackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubblebackgroundView.layer.cornerRadius = 18
        addSubview(bubblebackgroundView)
        addSubview(messageLable)
       // messageLable.text = "just test a long line,just test a long linejust test a long line,just test a long line,just test a long linejust test a long line,just test a long line,just test a long line,just test a long line,just test a long line"
        
       // messageLable.backgroundColor = .green
        messageLable.numberOfLines = 0
        messageLable.translatesAutoresizingMaskIntoConstraints =  false
        
        let constraints = [messageLable.topAnchor.constraint(equalTo: topAnchor, constant: 32),
       // messageLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
        messageLable.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -32),
        messageLable.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
        
        
        bubblebackgroundView.topAnchor.constraint(equalTo: messageLable.topAnchor, constant: -16),
        bubblebackgroundView.leadingAnchor.constraint(equalTo: messageLable.leadingAnchor, constant: -16),
        bubblebackgroundView.bottomAnchor.constraint(equalTo: messageLable.bottomAnchor, constant: 16),
        bubblebackgroundView.trailingAnchor.constraint(equalTo: messageLable.trailingAnchor, constant: 16),
        ]
        NSLayoutConstraint.activate(constraints)
       // messageLable.frame = CGRect(x:0,y:0,width: 100,height: 50)
      
        
       
        leadingConstraint = messageLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        leadingConstraint.isActive = false
        trailingConstraint = messageLable.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        trailingConstraint.isActive = true
        
    

        
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder): has not been implemented")
    }
}
