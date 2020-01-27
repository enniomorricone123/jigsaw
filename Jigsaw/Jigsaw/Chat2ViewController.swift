//
//  Chat2ViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase

class Chat2ViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate {
    var gameList = [game]()
    var topicList = [String]()
    var toId = String()
       //var matchUserDict1 = [String:Int]()
       var fromId = Auth.auth().currentUser!.uid
       var partner = Int()
  //  var matchUserDict = [String:Int]()
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        
//        if segue.identifier == "GoToQuiz"{
//        let QuizVC = segue.destination as! QuizViewController
//        QuizVC.gameList = self.gameList
//        QuizVC.topicList = self.topicList
//    //    QuizVC.matchUserDict = self.matchUserDict
//
//        }
        
        if segue.identifier == "GoToQuiz2"{
        let QuizVC = segue.destination as! QuizVC
        QuizVC.gameList = self.gameList
        QuizVC.topicList = self.topicList
    }
    }
    
    let tableView = UITableView()
    var user : User?
   // var name : String?
    let cellId = "cellId"
    var groupNum = 0
    
    lazy var inputTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Enter message..."
           textField.translatesAutoresizingMaskIntoConstraints = false
           textField.delegate = self
           return textField
       }()
    
   var counter = 60
          var timer = Timer()

      //  let label = UILabel()

       var messages = [Message]()
        var users =  [User]()
        var usersDictionary = [String: Message]()
        var messagesDictionary = [String: Message]()
    @IBOutlet weak var label: UILabel!
    
          // start timer
        

          // stop timer
          @IBAction func cancelTimerButtonTapped(sender: Any) {
              timer.invalidate()
          }

          // called every time interval from the timer
       @objc func timerAction() {
           if counter <= 0{
                     timer.invalidate()
                     counter = 60
               label.text = "Timer is up"
               self.performSegue(withIdentifier: "GoToQuiz2", sender: self)
               
                 }
           else{
              counter -= 1
              label.text = "Remaining time: \(counter)"
               
           }
          }

       override func viewDidLoad() {
           super.viewDidLoad()

        teamassign()
           
      //  navigationItem.title = "Chat room"
        setupInputComponents()
        view.addSubview(label)
     //   addButton()
           timer.invalidate()
           timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        observeUsers()
        observeMatch()
           observeMessages()
        self.tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        setupTableView()
        
        self.tableView.reloadData()
         
           // Do any additional setup after loading the view.
       }
    
    
 
    
    fileprivate func addButton(){
         let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitle("Button", for: UIControl.State.normal)
         button.setTitleColor(UIColor.black, for: UIControl.State.normal)
         self.view.addSubview(button)
         button.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
         button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
         button.widthAnchor.constraint(equalToConstant: 100).isActive = true
         button.heightAnchor.constraint(equalToConstant: 50).isActive = true
     }
    
    func teamassign(){
        if self.gameList.count == 1 {
            self.toId = ""
        }
        else{
        

            if partnerList1.contains(self.fromId){
                if partnerList1[0] == self.fromId{
                    self.toId = partnerList0[0]
                }
                else{
                    self.toId = partnerList0[1]
                }
                
                
            }
            else if partnerList0.contains(self.fromId){
                 if partnerList0[0] == self.fromId{
                                  self.toId = partnerList1[0]
                              }
                              else{
                                  self.toId = partnerList1[1]
                              }
            }
        
        }
    
    }
    
    func observeMessages() {
        
          let email = Auth.auth().currentUser!.email
          var name = String()
        //  for user in self.users {
          for user in users {
              if user.email?.lowercased() == email?.lowercased() {
                  name =  user.name ?? ""
                  
                  }
              if name == "" {
              name = "Guest"
                //  name = "test"
               //   name = "test"
              }

          }
        
          
          
          let timestamp = Int(Date().timeIntervalSince1970)
        
        if self.gameList.count == 1{
                   let hellomessage =  Message(dictionary: ["text": "Hi, we are group partners. Let's do a group chat!", /*"groupId": "group",*/ "fromId": self.fromId, "toId": self.toId, "timestamp": timestamp, "name": name, "group": self.groupNum] )
            self.messages.append(hellomessage)
               }
        else {
            let hellomessage =  Message(dictionary: ["text": "Hi, we are the partners who read the different resources. Let's chat!", /*"groupId": "group",*/ "fromId": self.fromId, "toId": self.toId, "timestamp": timestamp, "name": name, "group": self.groupNum] )
            self.messages.append(hellomessage)
        }
        
        
        
       
        
           let ref = Database.database().reference().child("messages")
           ref.observe(.childAdded, with: { (snapshot) in
               
               if let dictionary = snapshot.value as? [String: AnyObject] {
                   let message = Message(dictionary: dictionary)
                 if message.group == self.groupNum  {
                    if self.gameList.count == 1{
                        if message.toId == ""{
                            self.messages.append(message)
                        }
                    }
                    else{
                          if message.fromId == self.fromId && message.toId == self.toId{
                                                     self.messages.append(message)
                                                 }
                                                 else if message.toId == self.fromId && message.fromId == self.toId{
                                                     self.messages.append(message)
                                                 }
                    }
                       }
                 /*  if let toId = message.toId {*/
                      
                       
                   
                   
                   //this will crash because of background thread, so lets call this on dispatch_async main thread
                   DispatchQueue.main.async(execute: {
                  //  self.Chat.reloadData()
                       self.tableView.reloadData()
                    self.scrollToBottom(animated: false)
                   })
               }
               
               }, withCancel: nil)
       }
       
    func observeMatch(){

        Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/").child("match_active").observe(.childAdded, with: { (snapshot) in
            if (snapshot.value as? [String: AnyObject]) != nil {
                let groupTemp = String(snapshot.key)
            
                let groupInt =  Int(groupTemp.dropFirst(5)) ?? 0
                if groupInt > self.groupNum {
                self.groupNum =  groupInt
                }
                      }
                      
                      }, withCancel: nil)
  
    }
    
    func observeUsers(){

        Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/").child("users").observe(.childAdded, with: { (snapshot) in
                      if let dictionary = snapshot.value as? [String: AnyObject] {
                          let user = User(dictionary: dictionary)
               
                        self.users.append(user)
                      }
                      
                      }, withCancel: nil)
    }
   
       
     
       
    
    func observeUserMessages(){
        let ref =  Database.database().reference().child("messages")
         ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                _ = Message(dictionary: dictionary)
            }
            
     }, withCancel: nil)
    }
    
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
                    //for some reason uid = nil
                    return
                }
                
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
        //                self.navigationItem.title = dictionary["name"] as? String
                       // let user = User()
                        self.user = User(dictionary: dictionary)
                    
                        self.user?.id = snapshot.key
                        
                      //  self.setupNavBarWithUser(user)
                    }
                    
                    }, withCancel: nil)
    }
    

    func setupInputComponents(){
        let containerView = UIView()
              containerView.translatesAutoresizingMaskIntoConstraints = false
              
              view.addSubview(containerView)
              
              //ios9 constraint anchors
              //x,y,w,h
              containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
              containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
              containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
               sendButton.setTitle("Send", for: UIControl.State())
               sendButton.translatesAutoresizingMaskIntoConstraints = false
               sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        
               containerView.addSubview(sendButton)
               //x,y,w,h
               sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
               sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
               sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
               sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
               
               containerView.addSubview(inputTextField)
               //x,y,w,h
               inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
               inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
               inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
               inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
      /*
        if inputTextField.text == ""{
            sendButton.isUserInteractionEnabled = false
        }
        else{
            sendButton.isUserInteractionEnabled = true
        }
        */
        let separatorLineView3 = UIView()
              separatorLineView3.backgroundColor = UIColor.gray
                        separatorLineView3.translatesAutoresizingMaskIntoConstraints = false
                        containerView.addSubview(separatorLineView3)
                        //x,y,w,h
                        separatorLineView3.leftAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
                        separatorLineView3.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
                        separatorLineView3.widthAnchor.constraint(equalToConstant: 2).isActive = true
                        separatorLineView3.heightAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
               let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.gray
               separatorLineView.translatesAutoresizingMaskIntoConstraints = false
               containerView.addSubview(separatorLineView)
               //x,y,w,h
               separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
               separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
               separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
               separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let separatorLineView2 = UIView()
        separatorLineView2.backgroundColor = UIColor.gray
                  separatorLineView2.translatesAutoresizingMaskIntoConstraints = false
                  containerView.addSubview(separatorLineView2)
                  //x,y,w,h
                  separatorLineView2.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
                  separatorLineView2.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
                  separatorLineView2.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
                  separatorLineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
    }
    
    @objc func handleSend() {
       // let ref = Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/")
       
        
      
        
       // let name = Auth.auth().currentUser!.sel
        let ref = Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/").child("messages")
        let childRef = ref.childByAutoId()
       
        let email = Auth.auth().currentUser!.email
        var name = String()
      //  for user in self.users {
        for user in users {
            if user.email?.lowercased() == email?.lowercased() {
                name =  user.name ?? ""
                }
            if name == "" {
            name = "Guest"
              //  name = "test"
             //   name = "test"
            }

        }
        
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, /*"groupId": "group",*/ "fromId": self.fromId, "toId": self.toId, "timestamp": timestamp, "name": name, "group": groupNum] as [String : Any]
        childRef.updateChildValues(values as [AnyHashable : Any])
        inputTextField.text = ""
       }
    
    
    func setupTableView() {
        view.addSubview(tableView)
          
          tableView.dataSource = self
          tableView.delegate = self
          self.tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
          self.tableView.translatesAutoresizingMaskIntoConstraints = false
          
          self.tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
          self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
          self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true
          self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
          self.tableView.separatorStyle = .none
          self.tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
          
        
        let width = self.view.frame.width
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 30, width: width, height: 50))
        self.view.addSubview(navigationBar);
        
        if self.gameList.count == 1{
                 let navigationItem = UINavigationItem(title: "Group Discussion")
                 navigationBar.setItems([navigationItem], animated: false)
             }
             else{
                 let navigationItem = UINavigationItem(title: "Communication2")
                 navigationBar.setItems([navigationItem], animated: false)
             }
      }
    
    func scrollToBottom(animated: Bool = true) {
        let sections = self.tableView.numberOfSections
        let rows = self.tableView.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.tableView.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
    
   
    }



extension Chat2ViewController {
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                     return messages.count
                 }
                 
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = ChatMessageCell(style: .default, reuseIdentifier:  cellId)
                     
                     let message = messages[indexPath.row]
            
            if Auth.auth().currentUser!.uid != message.fromId{
            let name_text: String = message.name! + ":\n" + message.text!
            cell.messageLable.text = name_text
            }
            else{
                let name_text: String = message.text!
                cell.messageLable.text = name_text
            }
            cell.chatMessage = message
            
  
                     return cell
                 }
         /*
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                     return 50
                 }
 */
   }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


