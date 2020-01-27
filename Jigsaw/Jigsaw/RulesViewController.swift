//
//  RulesViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase

class RulesViewController: UIViewController {
    var teamAssignment = 0
    @IBOutlet weak var ruleTextView: UITextView!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    var resource_group1 = [String](repeating: "", count: 2)
    var resource_group2 = [String](repeating: "", count: 2)
    var questions_group1 = [[String]](repeating: [String](), count: 2)
    var questions_group2 = [[String]](repeating: [String](), count: 2)
    var answers_group1 = [[[String]]](repeating: [[String]](), count: 2)
    var answers_group2 = [[[String]]](repeating: [[String]](), count: 2)
    var topicList = [String]()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let globalDispatch = DispatchGroup()
    let globalDispatch1 = DispatchGroup()
    let globalDispatch2 = DispatchGroup()
    var timer = Timer()
    var counter = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        print("rule teamassign", self.teamAssignment)
        setupActivityIndicator()
        globalDispatch.enter()
        globalDispatch2.enter()
        pullResources()
        //IMPORTANT: In pull resources, we define topicList i.e. we determine
        //which topics are being chosen. The code for the three pull functions
        //are very similar, but we DO NOT define topicList again, so it's
        //important that pullResources is called first
        
        globalDispatch.notify(queue: .main) {
            self.globalDispatch1.enter()
            self.pullQuestions()
            print("entering GD1 notify")
            self.globalDispatch1.notify(queue: .main)
            {
                print("in GD1 notify")
                self.pullAnswers()
                print("out of answers")
            }
            
        }
    }
    
    @objc func timerAction() {
        if counter <= 0{
                  timer.invalidate()
                  counter = 15
            timerLabel.text = "Timer is up"
            timer.invalidate()
            globalDispatch2.notify(queue: .main)
            {
                self.performSegue(withIdentifier: "rulesToResource", sender: self)
            }
            
        }
        else{
           counter -= 1
           timerLabel.text = "Remaining time: \(counter)"
            
        }
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        activityIndicator.startAnimating()
        globalDispatch2.notify(queue: .main)
        {
            print("segueing")
            self.activityIndicator.stopAnimating()
            self.timer.invalidate()
            self.performSegue(withIdentifier: "rulesToResource", sender: self)
        }

    }
    func pullResources() {
        let storageRef = Storage.storage().reference(forURL: "gs://jigsaw-25200.appspot.com/").child("Topics") //Reference to parent folder
        let dispatch1 = DispatchGroup()
        let dispatch2 = DispatchGroup()
        let dispatch3 = DispatchGroup()
        dispatch1.enter()
        storageRef.list(withMaxResults: 1000, completion: { (storResult, err) in
            if err != nil {
                print(err!)
                return
            }
            self.topicList = [storResult.prefixes[0].name,storResult.prefixes[1].name]
            //"prefixes" is an array of folders that are under storageRef
            let gamesRef0 = storageRef.child(self.topicList[0])
            let gamesRef1 = storageRef.child(self.topicList[1])
            //Reference to two random games
            print("GamesRef0:")
            print(gamesRef0)
            print("GamesRef1:")
            print(gamesRef1)
            let teams = ["Group1","Group2"]
            let refs = [gamesRef0,gamesRef1]
            for i in 0..<refs.count {
                for team in teams {
                    dispatch2.enter()
                    refs[i].child(team).child("Resource").list(withMaxResults: 1000, completion: { (storResult, err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                        let files = storResult.items //This stores an array of the files (not folders) that are under Topics/[game]/[team]/Resource]
                        
                        dispatch3.enter()
                        files[0].getData(maxSize: 1024*1024) { data, error in
                            if let error = error {
                              print(error)
                            }
                            if team == "Group1" {
                                self.resource_group1[i] = String(bytes: data!, encoding: .utf8)!
                            }
                            else {
                                self.resource_group2[i] = String(bytes: data!, encoding: .utf8)!
                            }
                            dispatch3.leave()
                        }
                        
                        dispatch3.notify(queue: .main) {
                            dispatch2.leave()
                        }
                    })
                }
            }
            dispatch2.notify(queue: .main) {
                dispatch1.leave()
            }
        })
        dispatch1.notify(queue: .main) {
            self.globalDispatch.leave()
        }
        
    }
    
    func pullQuestions() {
        let storageRef = Storage.storage().reference(forURL: "gs://jigsaw-25200.appspot.com/").child("Topics") //Reference to parent folder
        let dispatch1 = DispatchGroup()
        let dispatch2 = DispatchGroup()
        let dispatch3 = DispatchGroup()
        dispatch1.enter()
        storageRef.list(withMaxResults: 1000, completion: { (storResult, err) in
            if err != nil {
                print(err!)
                return
            }
            
            let gamesRef0 = storageRef.child(self.topicList[0])
            let gamesRef1 = storageRef.child(self.topicList[1])
            //Reference to two random games
            
            let teams = ["Group1","Group2"]
            let refs = [gamesRef0,gamesRef1]
            for i in 0..<refs.count {
                for team in teams {
                    dispatch2.enter()
                    
                    refs[i].child(team).child("Questions").list(withMaxResults: 1000, completion: { (storResult, err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                        let files = storResult.items //This stores an array of the files (not folders) that are under Topics/[game]/[team]/Resource]
                        
                        dispatch3.enter()
                        files[0].getData(maxSize: 1024*1024) { data, error in
                            if let error = error {
                              print(error)
                            }
                            var temp = [String]()
                            for str in String(bytes: data!, encoding: .utf8)!.split(separator: "\n") {
                                temp.append(String(str))
                            }
                            if team == "Group1" {
                                self.questions_group1[i] = temp
                            }
                            else {
                                self.questions_group2[i] = temp
                            }
                            dispatch3.leave()
                        }
                        
                        dispatch3.notify(queue: .main) {
                            dispatch2.leave()
                        }
                    })
                }
            }
            dispatch2.notify(queue: .main) {
                dispatch1.leave()
            }
        })
        dispatch1.notify(queue: .main) {
            print("about to leave GD1")
            self.globalDispatch1.leave()
            print("left GD1")
        }
    }
    
    func pullAnswers() {
        let storageRef = Storage.storage().reference(forURL: "gs://jigsaw-25200.appspot.com/").child("Topics") //Reference to parent folder
        let dispatch1 = DispatchGroup()
        let dispatch2 = DispatchGroup()
        let dispatch3 = DispatchGroup()
        dispatch1.enter()
        storageRef.list(withMaxResults: 1000, completion: { (storResult, err) in
            if err != nil {
                print(err!)
                return
            }
            
            let gamesRef0 = storageRef.child(self.topicList[0])
            let gamesRef1 = storageRef.child(self.topicList[1])
            //Reference to two random games
            
            let teams = ["Group1","Group2"]
            let refs = [gamesRef0,gamesRef1]
            for i in 0..<refs.count {
                for team in teams {
                    dispatch2.enter()
                    
                    refs[i].child(team).child("Answers").list(withMaxResults: 1000, completion: { (storResult, err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                        let files = storResult.items //This stores an array of the files (not folders) that are under Topics/[game]/[team]/Resource]
                        
                        dispatch3.enter()
                        files[0].getData(maxSize: 1024*1024) { data, error in
                            if let error = error {
                              print(error)
                            }
                            var substrTemp = [String]()
                            var multiarray = [[String]]()
                            for str in String(bytes: data!, encoding: .utf8)!.split(separator: "\n") {
                                substrTemp.append(String(str))
                            }
                            for str in substrTemp {
                                var multiarray1 = [String]()
                                for substr in str.split(separator: ",") {
                                    multiarray1.append(String(substr))
                                }
                                multiarray.append(multiarray1)
                            }
                            if team == "Group1" {
                                self.answers_group1[i] = multiarray
                            }
                            else {
                                self.answers_group2[i] = multiarray

                            }
                            dispatch3.leave()
                        }
                        
                        dispatch3.notify(queue: .main) {
                            dispatch2.leave()
                        }
                    })
                }
            }
            dispatch2.notify(queue: .main) {
                dispatch1.leave()
            }
        })
        dispatch1.notify(queue: .main) {
            self.globalDispatch2.leave()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        
        let ResourceVC = (segue.destination as! ResourceViewController)
        ResourceVC.firstTime = true
        ResourceVC.topicList = self.topicList
//        ResourceVC.teamAssignment = self.teamAssignment

        ResourceVC.resource_group1 = resource_group1
        ResourceVC.resource_group2 = resource_group2
        
        ResourceVC.questions_group1 = questions_group1
        ResourceVC.questions_group2 = questions_group2
        
        ResourceVC.answers_group1 = answers_group1
        ResourceVC.answers_group2 = answers_group2
    }
}
