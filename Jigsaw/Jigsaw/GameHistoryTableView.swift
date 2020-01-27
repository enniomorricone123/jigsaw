//
//  GameHistoryViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase

class GameHistoryTableView: UITableViewController{

    var list : [String] = []
    
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return(list.count)
        }

         override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = list[indexPath.row]
            
            return(cell)
        }


        override func viewDidLoad() {
            super.viewDidLoad()

            let currentuser : FirebaseAuth.User? = Auth.auth().currentUser
            let currentuser_string : String = Auth.auth().currentUser!.uid
            if !currentuser!.isAnonymous {
                Database.database().reference().child("users").child(currentuser_string).observeSingleEvent(of: .value, with: { (snapshot) in
                    let user_map = snapshot.value as? NSDictionary
                    if(user_map != nil){
                        let history_map = user_map!["Game History"] as? NSDictionary
                        if history_map != nil{
                            let titles = history_map!.allKeys as NSArray
                            var title_string : String
                            for title in titles {
                                title_string = title as! String
                                self.list.append(title_string)
                            }
                            self.tableView.reloadData()
                        }
                    }
                    
                
                 
                })            }
            
            //need to fill in 
            
            
            
            
            
            
            self.tableView.reloadData()
            // Do any additional setup after loading the view, typically from a nib.
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }


    }

    
    
    
    
    
    
    
    
    
    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let currentuser : FirebaseAuth.User? = Auth.auth().currentUser
//        let dbRef = Database.database().reference()
//        if !currentuser!.isAnonymous {
//            let gameHistRef = dbRef.child("users").child(currentuser!.uid).child("Game History")
//            gameHistRef.observe(DataEventType.value, with: {(snapshot) in
//                if !snapshot.exists() {
//                    return
//                }
//                print("Printing children")
//                for child in (snapshot.children.allObjects as! [DataSnapshot]) {
//                    for q in (child.value as! Dictionary<String, String>).keys {
//                        let decoded = Data(base64Encoded: q, options: .init())
//                        let str = String(data: decoded ?? Data(), encoding: .utf8)
//                        print(str as Any)
//                    }
//                }
//            })
//        }
//    }
//}
