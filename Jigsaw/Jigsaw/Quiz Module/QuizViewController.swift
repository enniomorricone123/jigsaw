////
////  QuizViewController.swift
////  Jigsaw
////
////  Created by Grant Larson on 10/27/19.
////  Copyright © 2019 ECE564. All rights reserved.
////
//
//import UIKit
//
//class QuizViewController: UIViewController {
//
//    var topicList = [String]()
//    var gameList = [game]()
//    @IBOutlet weak var questions: UILabel!
//    @IBOutlet weak var QuestionNumber: UILabel!
//
////var matchUserDict = [String:Int]()
//
////Timer sections
//    var counter = 120
//    var timer = Timer()
//    @IBOutlet weak var Timerlabel: UILabel!
//
////    @IBAction func cancelTimerButtonTapped(sender: Any) {
////        timer.invalidate()
////    }
//
//    // called every time interval from the timer
//   @objc func timerAction() {
//       if counter <= 0{
//                 timer.invalidate()
//                 counter = 300
//           Timerlabel.text = "Timer is up"
//           performSegue(withIdentifier:"GoToResults", sender:self)
//        }
//
//       else{
//          counter -= 1
//          Timerlabel.text = "Remaining time: \(counter)"
//
//       }
//    }
//
//   override func viewDidLoad() {
//       super.viewDidLoad()
//       fetchQuiz()
//       CreateQuestion()
//       timer.invalidate()
//       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//   }
////
////    override func viewDidAppear(_ animated: Bool){
////           CreateQuestion()
////           timer.invalidate()
////           timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
////    }
////
//
////MARK: Quiz question setup
//    var point = 0
//    //this number need to be stored in firebase
//    var percentage = 0.0
//
//    var Questions = [String]()
//    var Answers = [[String]()]
//    var rightAnswerPlacement = 0
//    var button: UIButton = UIButton()
//    var currentQuestion = 0
//
//
//// fetch the contect of quiz from database
//    func fetchQuiz(){
//        let currentGame = self.gameList[0]
//        self.Questions = currentGame.questions
//        self.Answers = currentGame.answers
//    }
//    //should fetch content of current questions and answers from firebox database
//
//    func CreateQuestion(){
//        QuestionNumber.text="Question "+"\(currentQuestion+1)"
//        if self.Questions.count==0{
//            return
//        }
//        questions.text = self.Questions[currentQuestion]
//        let optionNumber = self.Answers[currentQuestion].count
//        self.rightAnswerPlacement=Int(arc4random_uniform(UInt32(optionNumber)))+1
//        var button: UIButton = UIButton()
//        var label : UILabel = UILabel()
//        var x = 1
//        for i in 1...self.Answers[currentQuestion].count{
//            //Create a button
//            button = view.viewWithTag(i) as! UIButton
//            label = (view.viewWithTag(i+4) as! UILabel)
//            label.isHidden = false
//            button.isHidden = false
//            if (i == Int(rightAnswerPlacement)){
//            button.setTitle(self.Answers[currentQuestion][0], for: .normal)
//                button.titleLabel?.textAlignment = NSTextAlignment.center
//                button.titleLabel?.numberOfLines = 0
//
//            }
//            else{
//            button.setTitle(self.Answers[currentQuestion][x], for: .normal)
//                button.titleLabel?.textAlignment = NSTextAlignment.center
//                button.titleLabel?.numberOfLines = 0
//                x += 1
//            }
//        }
//        if  optionNumber < 4 {
//            for i in (self.Answers[currentQuestion].count+1)...4{
//                label = (view.viewWithTag(i+4) as! UILabel)
//                label.isHidden = true
//                button = view.viewWithTag(i) as! UIButton
//                button.isHidden = true
//            }
//
//        }
//
//    self.currentQuestion += 1
//    }
//
//
//
//
//
//    // if user taps the correct answer, 1 points added. If user finishs answering all questions, go to result page
//
//    @IBAction func choseAnswer(_ sender: UIButton){
//        if (sender.tag == Int(self.rightAnswerPlacement)){
//            self.point += 1
//            self.percentage = Double(point/currentQuestion)
//        }
//        if (currentQuestion != Questions.count){
//            CreateQuestion()
//        }
//        else{
//
//            timer.invalidate()
//            // MARK: need to be filled in
//            // up to this point, quiz has been finished by the current user, need to
//            // 1. upload the percentage of correct answer (self.percentage)
//            // 2. update quiz has been finished (for use in next result controller)
//
//
//           performSegue(withIdentifier: "GoToResults", sender: self)
//        }
//    }
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
//        let resultVC = segue.destination as! ResultsViewController
//            resultVC.gameList = self.gameList
//            resultVC.topicList = self.topicList
//            resultVC.percentage = self.percentage
//    }
//
//
//}
//
