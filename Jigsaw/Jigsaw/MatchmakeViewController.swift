//
//  MatchmakeViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase
var matchUserDict = [String:Int]()
var partnerList0 = [String]()
var partnerList1 = [String]()
var match_num = String()
var level : Int = 0

class MatchmakeViewController: UIViewController {
    /*
    var matchUserDict = [String:Int]()

    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
     let RuleVC = segue.destination as! RulesViewController
        RuleVC.matchUserDict = self.matchUserDict
    }
  */
    var teamAssignment = 0
    let currentuser : String = Auth.auth().currentUser!.uid;
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var usersFound: UITextField!
    @IBOutlet weak var quitButton: UIBarButtonItem!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden = true
        startButton.isEnabled = false
       view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        Database.database().reference().child("users").child(currentuser).child("in_match").setValue("false")
        Database.database().reference().child("users").child(currentuser).child("current_score").setValue("not finished")

        startButton.isHidden = false
        startButton.isEnabled = true
        activitySpinner.style = UIActivityIndicatorView.Style.large
        activitySpinner.startAnimating()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        matchMake()
        Database.database().reference().child("users").child(currentuser).observe(.childChanged, with: { (snapshot) in
            let match_change = snapshot.value as? String
            if(match_change != nil && match_change!.count >= 5){
                let match_change : String = match_change!
                match_num = match_change
                let end_num = match_change.index(match_change.startIndex, offsetBy: 4)
                let match_str: String = String(match_change[...end_num])
                print(match_str)
                if(match_str == "match"){
                    self.activateStartButton()
                }
            }
            
        })
        
    }

    

    
 
    func activateStartButton(){
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
        searchText.text = "MATCH FOUND!"
        quitButton.isEnabled = false
        startButton.isHidden = false
        startButton.isEnabled = true
        Database.database().reference().removeAllObservers()

    }
    
    func matchMake(){
        Database.database().reference().child("match_making").child("queue").child(currentuser).setValue(true)
        determineIfFull()
    }
    
   
    
    func determineIfFull(){
        Database.database().reference().child("match_making").observeSingleEvent(of: .value, with: { (snapshot) in
            let users_in_queue = self.getQueue(snapshot: snapshot)
            if(users_in_queue!.count >= 4) {
                let users_to_play = self.get_users_queue(waiting_users: users_in_queue!)
                self.convertToFullGame(playing_users: users_to_play, match : "queue")
                self.activateStartButton()
            }
        }) { (error) in
               print(error.localizedDescription)
           }
    }
    
    
    func getQueue(snapshot : DataSnapshot) -> NSArray? {
        let matches_in_making = snapshot.value as? NSDictionary
        let users_map = matches_in_making?["queue"] as? NSDictionary
        let users_in_queue = users_map?.allKeys as NSArray?
        return users_in_queue
    
    }
    
    func updateCount(count : Int){
        usersFound.text = "Users Found: "+String(count)+"/3"
    }
    
    func get_users_queue(waiting_users : NSArray) -> [String] {
        var users_to_play : [String] = []
        for index in 0...3 {
            users_to_play.append(waiting_users[index] as! String)
        }
        return users_to_play
    }
    func getMatchesActiveList(snapshot : DataSnapshot) -> NSArray {
        let matches_active = snapshot.value as? NSDictionary
        if(matches_active == nil){
            return NSArray()
        }
        let matches_active_list = matches_active!.allKeys as NSArray
        return matches_active_list
    }
    
    
    
    func convertToFullGame(playing_users : [String], match : String){
        var active_match = String()
        Database.database().reference().child("match_active").observeSingleEvent(of: .value, with: { (snapshot) in
            let matches_active_list = self.getMatchesActiveList(snapshot: snapshot)
            if(matches_active_list.count == 2){
                active_match = "2"
            }
            else{
                active_match = String(self.find_max(active_list: matches_active_list)+1)
            }
            match_num = active_match
            let team = [1, 0, 1, 0]
            var team_index : Int = 0
            for player in playing_users {
                if player == self.currentuser{
                    self.teamAssignment = team[team_index]
                    print("same")
                    
                }
                print(self.currentuser)
                print(player)
                  Database.database().reference().child("match_making").child(match).child(player).removeValue()
                  Database.database().reference().child("match_active").child("match"+active_match).child(player).setValue(team[team_index])
                Database.database().reference().child("users").child(player).child("in_match").setValue("match"+active_match)

          //      matchUserDict.updateValue(team[team_index], forKey: player)//
                      team_index+=1
               }
            match_num = "match"+active_match
        Database.database().reference().child("match_active").child(match_num).child("result").setValue("not applicable")
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func find_max(active_list : NSArray) -> Int {
        var max_int : Int = -1
        for current_element in active_list {
            let elem_string = current_element as? String
            let start_num = elem_string!.index(elem_string!.startIndex, offsetBy: 5)
            let elem_str_int : String = String(elem_string![start_num...])
            let elem_int = Int(elem_str_int)
            max_int = max(max_int, elem_int!)
        }
        return max_int
    }
    
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToRules"{
        let RuleVC = segue.destination as! RulesViewController
        RuleVC.teamAssignment =  self.teamAssignment
    }
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
