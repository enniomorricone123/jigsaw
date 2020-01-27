//
//  ResultsViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase
class ResultsViewController: UIViewController {
    
    @IBOutlet weak var ResultDisplay: UITextView!
    
    @IBOutlet weak var GoToNext: UIButton!
    let currentuser : String = Auth.auth().currentUser!.uid;
    var resultType = ""
    var gameList = [game]()
    var topicList = [String]()
    var percentage : Double = Double()
    var passed : [String : Bool] = [:]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        passed = [:]
        GoToNext.isHidden = true
        var i_passed : String = "false"
        passed[currentuser] = false
        if(percentage >= 0.75) {
            i_passed = "true"
            passed[currentuser] = true
        }
    Database.database().reference().child("users").child(currentuser).child("current_score").setValue(i_passed)
        
    Database.database().reference().child("users").child(currentuser).child("in_match").observeSingleEvent(of: .value, with: { (snapshot) in
           let match_value = snapshot.value as? NSString
        self.observeMatchActive(match_number: match_value! as String)
        })
        
    }

    //decide if both partner pass, if so, go to next quiz (resource),if not stay at this quiz( go back to the chatroom)

    func checkIfPartnersPassed() {
    Database.database().reference().child("users").child(currentuser).child("in_match").observeSingleEvent(of: .value, with: { (snapshot) in
           let match_value = snapshot.value as? NSString
        self.completed_match(match_number: match_value! as String)
        })
    }
    
    func observeMatchActive(match_number : String){
        Database.database().reference().child("match_active").child(match_number).observe(.childChanged, with: { (snapshot) in
            let match_result = snapshot.value as! String
            if(match_result == "true"){
                self.NextStep(match_number : match_number, passed : true)
                
            }
            else if (match_result == "false"){
                self.NextStep(match_number : match_number, passed : false)
            }
            })
        self.checkIfPartnersPassed()

    }
    func completed_match(match_number : String) {
        Database.database().reference().child("match_active").observeSingleEvent(of: .value, with: { (snapshot) in
            let active_matches = snapshot.value as? NSDictionary
            let users_in_match_map = active_matches?[match_number] as? NSDictionary
            let users_in_map_array = users_in_match_map?.allKeys as NSArray?
            self.found_users(users: users_in_map_array!, match_number : match_number)
            
        })
    }
    
    func found_users(users : NSArray, match_number : String){
 
            Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                var user_string : String
                for user in users {
                    user_string = user as! String
                    if user_string != "result" {
                        let users_map = snapshot.value as? NSDictionary
                        let user_map = users_map![user_string] as? NSDictionary
                        let result = user_map!["current_score"] as! String
                        if(result == "true"){
                            self.passed[user_string] = true;
                        }
                        else if(result == "false"){
                            self.passed[user_string] = false
                        }
                    }
                }
                self.check_users(match_number: match_number)
            
            })
        }

    
    func check_users(match_number : String){
        if(self.passed.keys.count == 4){
            var did_pass : Bool = true
            for bools in self.passed.values {
                did_pass = bools && did_pass
            }
            var did_pass_string : String = "false"
            if(did_pass) {
                did_pass_string = "true"
            }
        Database.database().reference().child("match_active").child(match_number).child("result").setValue(did_pass_string)
        }
        
    }
    

 
    
    
    //MARK: NEED TO BE FILLED IN
    func BothPartnerPass()->Bool{
        //check if the partner pass the game or not on firebase
        return true
    }
    
    //MARK: NEED TO BE FILLED IN
    func BothPartnerFinish()->Bool{
        // check if your partner has finish the quiz series
        return true
    }
    

    func EndOfGame()->Bool{
        //check if reach the end of the game
        if gameList.count==1{
            return true
        }
        else{
            return false
        }

    }
    
    // setting up the result message and button segues
    
    var button = UIButton()
    func PageSetup(_ ResultType:String){
        if ResultType == "PassedAndDone"{
            self.ResultDisplay.text = "Congratulations!  Your team has successfully finished this Game! Click done to exit game."
            
            
            self.GoToNext.setTitle ("Done", for: .normal)
        
            }
        else if ResultType == "PassedAndNext"{
            self.ResultDisplay.text = "Congratulations!  Your team has successfully passed the quiz! Please click Continue to go to next section. "
            self.GoToNext.setTitle ("Continue", for: .normal)
        }
        else if ResultType == "FailedQuiz"{
            self.ResultDisplay.text = "Sorry! Your team did not pass the quiz! Click below to try it again"
            self.GoToNext.setTitle ("Try It Again", for: .normal)
        }
        
        else {
            self.ResultDisplay.text = "Please wait for your teammates to finish the quiz"
            self.GoToNext.setTitle ("Waiting", for: .normal)
            
            
        }
        
    }
    
    
    @IBAction func GoToNextPressed(_ sender: UIButton) {
        if self.resultType != ""{
            timer.invalidate()
Database.database().reference().child("match_active").child(match_num).child("result").setValue("not applicable")
               Database.database().reference().child("users").child(currentuser).child("current_score").setValue("not finished")
        performSegue(withIdentifier: self.resultType, sender: sender)
        }
    }
    

    
 
    // decide what is the next step
    func NextStep(match_number : String, passed : Bool){
        // if both partner finish
        Database.database().reference().removeAllObservers()
        match_num = match_number
        GoToNext.isHidden = false
        
        // if reach the end of the game, exit the game
      
            if passed {
                let currentuser : FirebaseAuth.User? = Auth.auth().currentUser
                if !currentuser!.isAnonymous {
                    let dbRef = Database.database().reference()
                    print(self.topicList[0] + "has sucessfully uploaded to the game history")
                    dbRef.child("users").child(currentuser!.uid).child("Game History").child(self.topicList[0])
                }
                
                if EndOfGame(){
                    PageSetup("PassedAndDone")
                    self.resultType="PassedAndDone"
                    timer.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                }
                    //if not the end of the game, go to the next resource
                else{
                    PageSetup("PassedAndNext")
                    self.resultType="PassedAndNext"
                    timer.invalidate()
                        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                }
        }
            else {
                PageSetup("FailedQuiz")
                self.resultType="FailedQuiz"
                timer.invalidate()
               timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        if segue.identifier == "PassedAndDone" {
           //MARK: UPDATE USER STATUS
        }
        if segue.identifier == "PassedAndNext" {
            let resourceVC = segue.destination as! ResourceViewController
            self.gameList.removeFirst()
            self.topicList.removeFirst()
            resourceVC.gameList = self.gameList
            resourceVC.topicList = self.topicList
            resourceVC.firstTime = false
        }
        
        else if segue.identifier == "FailedQuiz"{
            let resourceVC = segue.destination as! ResourceViewController
            resourceVC.gameList = self.gameList
            resourceVC.topicList = self.topicList
            resourceVC.firstTime = false
        }
        
      }
      
    
    
    //MARK:Timer for automatic redirection
    var counter = 30
    var timer = Timer()
     @IBOutlet weak var label: UILabel!
     @IBAction func cancelTimerButtonTapped(sender: Any) {
         timer.invalidate()
     }
     // automatic redirect to corresponding page if no response of user
    @objc func timerAction() {
        if counter <= 0{
                  timer.invalidate()
                  counter = 10
            label.text = "Timer is up"
            self.performSegue(withIdentifier: self.resultType, sender: self)
        }
    else{
            if self.resultType == "PassedAndDone"{
                counter -= 1
                label.text = "Exit game in \(counter) seconds"
            }
            
            else if self.resultType == "PassedAndNext"{
                counter -= 1
                label.text = "Go to next section in \(counter) seconds"
            }
            
            else if self.resultType == "FailedQuiz"{
                counter -= 1
                label.text = "Redo the game \(counter) seconds"
            }
        }
       }
}
