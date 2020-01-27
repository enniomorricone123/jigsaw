//
//  QuizCVCell.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//
import UIKit

protocol QuizCVCellDelegate: class {
    func didChooseAnswer(btnIndex: Int, prev: Int)
}

class QuizCVCell: UICollectionViewCell {
    
    var btn1: UIButton!
    var btn2: UIButton!
    var btn3: UIButton!
    var btn4: UIButton!
   
    
    
//    var labelArray = [label1,label2,label3,label4]
    var btnsArray = [UIButton]()
    
    weak var delegate: QuizCVCellDelegate?
    
    var question: Question? {
        didSet {
            guard let unwrappedQue = question else { return }
            let n = question!.options.count
            lblQue.text = unwrappedQue.questionText
            setUpButton(unwrappedQue,numberOptions:n-1)
            if unwrappedQue.isAnswered {
                btnsArray[unwrappedQue.ansChose].backgroundColor = UIColor.green
                
            }
        }
    }
    
    
    
    
    
    var numberOption = 4
    func setUpButton(_ unwrappedQue:Question,numberOptions:Int){
       
        var button = UIButton()
        for i in 0...numberOptions-1 {
            button = btnsArray[i]
            button.isHidden = false
           
            button.setTitle(unwrappedQue.options[i], for: .normal)
//            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        if numberOptions < 4{
            self.numberOption = numberOptions
//        for j in numberOptions+1..<3{
//            button = btnsArray[j]
//            button.isHidden = true
//        }
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        btnsArray = [btn1, btn2, btn3, btn4]
    }
    
    
    @objc func btnOptionAction(sender: UIButton) {
        guard let unwrappedQue = question else { return }
        if !unwrappedQue.isAnswered {
            delegate?.didChooseAnswer(btnIndex: sender.tag, prev: 0)
        }
        else {
            if !(unwrappedQue.ansChose == -1) {
                if unwrappedQue.ansChose == unwrappedQue.correctAns{
                delegate?.didChooseAnswer(btnIndex: sender.tag, prev:-1)
                }
                else {
                delegate?.didChooseAnswer(btnIndex: sender.tag, prev:0)
                }
                
        }
    }
    
    }
    
    //
    
    
    override func prepareForReuse() {
        btn1.backgroundColor=UIColor.white
        btn2.backgroundColor=UIColor.white
        btn3.backgroundColor=UIColor.white
        btn4.backgroundColor=UIColor.white
    }
    
    func setupViews() {

        addSubview(lblQue)
        lblQue.topAnchor.constraint(equalTo: self.topAnchor,constant: 100).isActive=true
        lblQue.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive=true
        lblQue.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive=true
        lblQue.heightAnchor.constraint(equalToConstant: 150).isActive=true

        let btnWidth: CGFloat = 360
        let btnHeight: CGFloat = 100
        let labelWidth : CGFloat = 20
           
        // option A
     
        btn1 = getButton(tag: 0)
        addSubview(btn1)
        NSLayoutConstraint.activate([btn1.topAnchor.constraint(equalTo: lblQue.bottomAnchor, constant: 20), btn1.leftAnchor.constraint(equalTo:self.leftAnchor, constant: 40), btn1.widthAnchor.constraint(equalToConstant: btnWidth), btn1.heightAnchor.constraint(equalToConstant: btnHeight)])
        
        btn1.addTarget(self, action: #selector(btnOptionAction), for: .touchUpInside)
        
        addSubview(label1)
        label1.centerYAnchor.constraint(equalTo: btn1.centerYAnchor).isActive=true
        label1.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive=true
        label1.heightAnchor.constraint(equalToConstant: labelWidth).isActive=true

    

        // option B
        btn2 = getButton(tag: 1)
        addSubview(btn2)
        NSLayoutConstraint.activate([btn2.topAnchor.constraint(equalTo: btn1.bottomAnchor, constant: 20), btn2.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40), btn2.widthAnchor.constraint(equalToConstant: btnWidth), btn2.heightAnchor.constraint(equalToConstant: btnHeight)])
         btn2.addTarget(self, action: #selector(btnOptionAction), for: .touchUpInside)


        addSubview(label2)
        label2.centerYAnchor.constraint(equalTo: btn2.centerYAnchor).isActive=true
        label2.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive=true
        label2.heightAnchor.constraint(equalToConstant: labelWidth).isActive=true


        // option C
        
       btn3 = getButton(tag: 2)
        
       if (self.numberOption >= 3) {
            addSubview(btn3) }
//       addSubview(btn3)
       NSLayoutConstraint.activate([btn3.topAnchor.constraint(equalTo: btn2.bottomAnchor, constant: 20), btn3.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40), btn3.widthAnchor.constraint(equalToConstant: btnWidth), btn3.heightAnchor.constraint(equalToConstant: btnHeight)])
        btn3.addTarget(self, action: #selector(btnOptionAction), for: .touchUpInside)
        
        if (self.numberOption >= 3) {
            addSubview(label3)
            
        }
       
       label3.centerYAnchor.constraint(equalTo: btn3.centerYAnchor).isActive=true
       label3.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive=true
       label3.heightAnchor.constraint(equalToConstant: labelWidth).isActive=true

    
        //option D
        
       btn4 = getButton(tag: 3)
       
        
       if (self.numberOption >= 4) {
            addSubview(btn4) }
        
       NSLayoutConstraint.activate([btn4.topAnchor.constraint(equalTo: btn3.bottomAnchor, constant: 20), btn4.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40), btn4.widthAnchor.constraint(equalToConstant: btnWidth), btn4.heightAnchor.constraint(equalToConstant: btnHeight)])
        btn4.addTarget(self, action: #selector(btnOptionAction), for: .touchUpInside)

        if (self.numberOption >= 4) {
            addSubview(label4)
        }
//       addSubview(label4)
       label4.centerYAnchor.constraint(equalTo: btn4.centerYAnchor).isActive=true
       label4.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive=true
       label4.heightAnchor.constraint(equalToConstant: labelWidth).isActive=true
        
       
    }
    
    func getButton(tag: Int) -> UIButton {
        let btn = UIButton()
        btn.tag = tag
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 4,left: 4,bottom: 4,right: 4)
        btn.backgroundColor = UIColor.white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }

    
    let label1: UILabel = {
        let label=UILabel()
        label.text = "A"
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()

    let label2: UILabel = {
           let label=UILabel()
           label.text = "B"
           label.textColor = UIColor.black
           label.textAlignment = .left
           label.font = UIFont.systemFont(ofSize: 24)
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints=false
           return label
    }()

    let label3: UILabel = {
           let label=UILabel()
           label.text = "C"
           label.textColor = UIColor.black
           label.textAlignment = .left
           label.font = UIFont.systemFont(ofSize: 24)
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints=false
           return label
    }()

    let label4: UILabel = {
           let label=UILabel()
           label.text = "D"
           label.textColor = UIColor.black
           label.textAlignment = .left
           label.font = UIFont.systemFont(ofSize: 24)
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints=false
           return label
    }()
    
    
    let lblQue: UILabel = {
        let lbl=UILabel()
        lbl.text="This is a question and you have to answer it?"
        lbl.textColor=UIColor.black
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
