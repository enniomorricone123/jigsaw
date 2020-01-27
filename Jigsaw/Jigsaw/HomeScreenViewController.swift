//
//  ProfileViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase


class HomeScreenViewController: UIViewController {
    
    
    @IBOutlet weak var enterInfoButton: UIButton!
    @IBOutlet weak var gameHistoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "1.jpeg")!)
          var imageView : UIImageView
          imageView  = UIImageView(frame:CGRect(x: 10, y: 200, width: 400, height: 50));
          imageView.image = UIImage(named:"JigsawText.png")
          self.view.addSubview(imageView)
        

        guard let user = Auth.auth().currentUser else {
            return
        }
        if user.isAnonymous {
            enterInfoButton.isEnabled = false
            gameHistoryButton.isEnabled = false
        }
        else {
            enterInfoButton.isEnabled = true
            gameHistoryButton.isEnabled = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        Database.database().reference().removeAllObservers()
    }
    
    
    

    
    @IBAction func quitMatchMaking(unwindSegue: UIStoryboardSegue){
        let currentuser : String? = Auth.auth().currentUser?.uid;
        Database.database().reference().child("match_making").child("queue").child(currentuser!).removeValue()


    }

}
