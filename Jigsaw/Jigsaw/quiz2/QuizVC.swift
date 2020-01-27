//
//  QuizVC.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit

struct Question {
    let questionText: String
    let options: [String]
    let correctAns: Int
    var ansChose: Int
    var isAnswered: Bool

}

class QuizVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var questionsArray : [Question] = []
    var topicList = [String]()
    var gameList = [game]()
    var myCollectionView: UICollectionView!
    var score: Int = 0
    var currentQuestionNumber = 1
    var window: UIWindow?
    var currentGame = game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //timer
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        
        self.view.backgroundColor=UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        myCollectionView=UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(QuizCVCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.white
        myCollectionView.isPagingEnabled = true
        
        self.view.addSubview(myCollectionView)
        prepareQuestions()
        setupViews()
    }
    
    
    
    //MARK: Timer sections
        var counter = 60
        var timer = Timer()
        
    
        let Timerlabel: UILabel = {
        let label=UILabel()
        label.text = "Timer"
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
        
        
    //    @IBAction func cancelTimerButtonTapped(sender: Any) {
    //        timer.invalidate()
    //    }

        // called every time interval from the timer
       @objc func timerAction() {
           if counter <= 0{
                     timer.invalidate()
                     counter = 300
               Timerlabel.text = "Timer is up"
               performSegue(withIdentifier:"GoToResults2", sender:self)
            }
            
           else{
              counter -= 1
              Timerlabel.text = "Remaining time: \(counter) s"
           }
        }
    
    
    
    
    
    func prepareQuestions(){
        print(self.topicList)
        self.currentGame = self.gameList[0]
        let n = self.currentGame.questions.count
        
        for i in 0..<n{
            let questionText = currentGame.questions[i]
            let answerOptions = currentGame.answers[i]
            let CurrentQuiz = Question(questionText:questionText,options:answerOptions,correctAns:0,ansChose:-1,isAnswered:false)
            self.questionsArray.append(CurrentQuiz)
        }
    
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! QuizCVCell
        cell.question=self.questionsArray[indexPath.row]
        cell.delegate=self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setQuestionNumber()
    }
    
    func setQuestionNumber() {
        let x = myCollectionView.contentOffset.x
        let w = myCollectionView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if currentPage < self.questionsArray.count {
            lblQueNumber.text = "Question: \(currentPage+1) / \(self.questionsArray.count)"
            currentQuestionNumber = currentPage + 1
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let resultVC = segue.destination as! ResultsViewController
            timer.invalidate()
            resultVC.gameList = self.gameList
            resultVC.topicList = self.topicList
            resultVC.percentage = Double(self.score / self.questionsArray.count)
    }

    
    @objc func btnPrevNextAction(sender: UIButton) {
        if sender == btnNext && currentQuestionNumber == self.questionsArray.count {
            performSegue(withIdentifier:"GoToResults2", sender:self)

        }
        
        let collectionBounds = self.myCollectionView.bounds
        var contentOffset: CGFloat = 0
        if sender == btnNext {
            contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x + collectionBounds.size.width))
            currentQuestionNumber += currentQuestionNumber >= self.questionsArray.count ? 0 : 1
        } else {
            contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x - collectionBounds.size.width))
            currentQuestionNumber -= currentQuestionNumber <= 0 ? 0 : 1
        }
        self.moveToFrame(contentOffset: contentOffset)
        lblQueNumber.text = "Question: \(currentQuestionNumber) / \(self.questionsArray.count)"
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.myCollectionView.contentOffset.y ,width : self.myCollectionView.frame.width,height : self.myCollectionView.frame.height)
        self.myCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    func setupViews() {
        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=true
        
        self.view.addSubview(btnPrev)
        btnPrev.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnPrev.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive=true
        btnPrev.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        btnPrev.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(btnNext)
        
        btnNext.heightAnchor.constraint(equalTo: btnPrev.heightAnchor).isActive=true
        btnNext.widthAnchor.constraint(equalTo: btnPrev.widthAnchor).isActive=true
        btnNext.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        btnNext.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(lblQueNumber)
        lblQueNumber.heightAnchor.constraint(equalToConstant: 20).isActive=true
        lblQueNumber.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblQueNumber.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive=true
        lblQueNumber.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive=true
        lblQueNumber.text = "Question: \(1) / \(self.questionsArray.count)"
        
//        self.view.addSubview(lblScore)
//        lblScore.heightAnchor.constraint(equalTo: lblQueNumber.heightAnchor).isActive=true
//        lblScore.widthAnchor.constraint(equalTo: lblQueNumber.widthAnchor).isActive=true
//        lblScore.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive=true
//        lblScore.bottomAnchor.constraint(equalTo: lblQueNumber.bottomAnchor).isActive=true
//        lblScore.text = "Score: \(score) / \(self.questionsArray.count)"
        
        
        //timer sesstion
        self.view.addSubview(Timerlabel)
        Timerlabel.heightAnchor.constraint(equalToConstant: 20).isActive=true
        Timerlabel.widthAnchor.constraint(equalToConstant: 180).isActive=true
        Timerlabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20).isActive=true
        Timerlabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive=true
        
        
        
    }
    
    let btnPrev: UIButton = {
        let btn=UIButton()
        btn.setTitle("< Previous", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.orange
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnPrevNextAction), for: .touchUpInside)
        return btn
    }()
    
    let btnNext: UIButton = {
        let btn=UIButton()
        btn.setTitle("Next >", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.purple
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnPrevNextAction), for: .touchUpInside)
        return btn
    }()
    
    let lblQueNumber: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.gray
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
//    let lblScore: UILabel = {
//        let lbl=UILabel()
//        lbl.text="0 / 0"
//        lbl.textColor=UIColor.gray
//        lbl.textAlignment = .right
//        lbl.font = UIFont.systemFont(ofSize: 16)
//        lbl.translatesAutoresizingMaskIntoConstraints=false
//        return lbl
//    }()
}

extension QuizVC: QuizCVCellDelegate {
    func didChooseAnswer(btnIndex: Int, prev:Int) {
        let centerIndex = getCenterIndex()
        guard let index = centerIndex else { return }
        self.questionsArray[index.item].isAnswered=true
        
        if self.questionsArray[index.item].correctAns != btnIndex {
            questionsArray[index.item].ansChose = btnIndex
        } else {
            questionsArray[index.item].ansChose = btnIndex
            score += 1
        }
        
        score += prev
//        lblScore.text = "Score: \(score) / \(self.questionsArray.count)"
        myCollectionView.reloadItems(at: [index])
    }
    
    func getCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.myCollectionView.center, to: self.myCollectionView)
        let index = myCollectionView!.indexPathForItem(at: center)
        print(index ?? "index not found")
        return index
    }
}














