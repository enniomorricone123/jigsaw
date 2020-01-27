//
//  ResourceViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase



class ResourceViewController: UIViewController {
/*
    var matchUserDict = [String:Int]()
*/
    var teamAssignment = -1
    var counter = 30
    var timer = Timer()
    
    var resource_group1 = [String]()
    var questions_group1=[[String]]()
    var answers_group1=[[[String]]]()
       
    var resource_group2 =  [String]()
    var questions_group2=[[String]]()
    var answers_group2=[[[String]]]()
    
    var content:String?
    var titleName:String?
    var gameList = [game]()
    var topicList = [String]()
    var firstTime = true
    
    var groupNum = 0

    @IBOutlet weak var Timerlabel: UILabel!
    @IBAction func cancelTimerButtonTapped(sender: Any) {
        timer.invalidate()
       }

       // called every time interval from the timer
    @objc func timerAction() {
        if counter <= 0{
                  timer.invalidate()
                  counter = 30
            Timerlabel.text = "Timer is up"
            timer.invalidate()
            self.performSegue(withIdentifier: "GoToChat", sender: self)
        }
        else{
           counter -= 1
           Timerlabel.text = "Remaining time: \(counter)"
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let ChatVC = segue.destination as! ChatViewController
            ChatVC.gameList = self.gameList
            ChatVC.topicList = self.topicList
        timer.invalidate()
      
       // ChatVC.matchUserDict = self.matchUserDict
    }
    
    
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ResourceTextView: UITextView!
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        observeMatch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                      // your code here
                      self.observeMatchteam()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                          // your code here
                          let uid = Auth.auth().currentUser?.uid
                              /*print("0list", partnerList0)
                              print("1list", partnerList1)
                              print(uid!)*/
                              if partnerList0.contains(uid!){
                                  self.teamAssignment =  0
                              }
                              else if partnerList1.contains(uid!) {
                                  self.teamAssignment =  1
                              }
                              
                              print("resrouce teamassign", self.teamAssignment)
                              if self.firstTime{
                                  self.fetchResource()
                                
                              }
                              
                              
                              
                              
                              self.setupGame()

                              self.timer.invalidate()
                              self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                              self.ResourceTextView.text = self.content
                              self.TitleLabel.text = "Topic: "+"\(self.titleName!)"
            }
        }
    
        

 
        
    }
    
    func observeMatch(){

      Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/").child("match_active").observe(.childAdded, with: { (snapshot) in

        let groupTemp = String(snapshot.key)
        let groupInt =  Int(groupTemp.dropFirst(5)) ?? 0
       
                    if groupInt > self.groupNum {
                    self.groupNum =  groupInt
                    }
                 
                    
                   
       // self.groupNum = groupInt
      }
                          , withCancel: nil)
         
       // print(match_num)
        
        
    }
    
    func observeMatchteam(){
     matchUserDict.removeAll()
               partnerList1.removeAll()
               partnerList0.removeAll()
               Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/").child("match_active").child("match"+String(self.groupNum)).observe(.childAdded, with: { (snapshot) in
                
                if(snapshot.key != "result"){
                        matchUserDict.updateValue(snapshot.value as! Int, forKey: snapshot.key)
                        if snapshot.value as! Int  == 0{
                            partnerList0.append(snapshot.key)
                        }
                        else{
                            partnerList1.append(snapshot.key)
                        }
                   //      print("snapshotend")
                    }
        
                                     }, withCancel: nil)
         //      partnerList1.sort(by: >)
           //    partnerList0.sort(by: >)

    }
    
    //MARK: NEED TO BE FILLED IN
    func SubteamAssignment()->String{
        //retrieve the current team assignemnt 1 or 0
        print(self.teamAssignment)
        if self.teamAssignment == -1 {
            return "0"
        }
        else {return ["0","1"][self.teamAssignment]
        }
    
    }
    

    func fetchResource(){
     //   let subteam = "1"//SubteamAssignment()
        
        //MARK: USE LOCAL MEMORY FIRST
        let subteam = SubteamAssignment()
        
        
        
        
        let game_group1round1=game(resource:self.resource_group1[0],questions:self.questions_group1[0],answers:self.answers_group1[0])
        let game_group2round1=game(resource:self.resource_group2[0],questions:self.questions_group2[0],answers:self.answers_group2[0])
        
        let game_group1round2=game(resource:self.resource_group1[1],questions:self.questions_group1[0],answers:self.answers_group1[0])
        let game_group2round2=game(resource:self.resource_group2[1],questions:self.questions_group2[1],answers:self.answers_group2[1])
       
        if subteam == "0" {
            self.gameList=[game_group1round1,game_group1round2]
            print("subteam 0")
            print(gameList[0].resource)
            print(gameList[1].resource)
        }
        else{
            self.gameList=[game_group2round1,game_group2round2]
            print("subteam 1")
            print(gameList[0].resource)
            print(gameList[1].resource)
        }
    }
    func setupGame(){
        self.titleName = self.topicList[0]
        self.content = self.gameList[0].resource
    }
}
