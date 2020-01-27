//
//  ViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func handleRegister(_ sender: Any) {
        activityIndicator.startAnimating()
        if let userName = userNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let passwordConf = passwordConfTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: {(user, err) in
                if err != nil {
                    print("Fields not entered correctly")
                    self.showAlert(title: "Registration failed", message: err!.localizedDescription)
                    self.activityIndicator.stopAnimating()
                    return
                }
                if passwordConf != password {
                    self.showAlert(title: "Password mismatch", message: "Password and password confirmation fields do not match")
                    self.activityIndicator.stopAnimating()
                    return
                }
                print("Successful creation")
                guard let uid = user?.user.uid else {
                    print("Invalid user")
                    self.activityIndicator.stopAnimating()
                    return
                }
                let values = ["name": userName, "email": email]
                let ref = Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/")
                let usersRef = ref.child("users").child(uid)
                usersRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
                    if error != nil {
                        print("error in user save")
                        self.activityIndicator.stopAnimating()
                        return
                    }
                })
                
                
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "loginOrRegSuccess", sender: self)
                
                return
            })
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func handlelogin(_ sender: Any) {
        self.activityIndicator.startAnimating()
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, err) in
                if err != nil {
                    self.showAlert(title: "Login failed", message: err!.localizedDescription)
                    self.activityIndicator.stopAnimating()
                    return
                }
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "loginOrRegSuccess", sender: self)
            })
        }
    }
    
    @IBOutlet weak var inputsContainerView: UIView!
    
    @IBOutlet weak var guestButton: UIButton!
    
    
    @IBAction func guestButtonClicked(_ sender: Any) {
        self.activityIndicator.startAnimating()
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error != nil{
                print(error!)
                self.activityIndicator.stopAnimating()
                return
            }
            guard let _ = authResult?.user else {
                print("didnt work")
                
                self.activityIndicator.stopAnimating()
                return
            }
            let uid = authResult?.user.uid
            let username = String(uid.hashValue)
            let end = username.index(username.startIndex, offsetBy: 5)
            let values = ["name": "guest " + username[username.startIndex...end]]
            let ref = Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/")
            let usersRef = ref.child("users").child((authResult?.user.uid)!)
            usersRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
                if error != nil {
                    print("error in user save")
                    self.activityIndicator.stopAnimating()
                    return
                }
            })
            
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "guestButton", sender: self)

        }
    }
    
    
    @IBOutlet weak var titleBox: UILabel!
    
    @IBOutlet weak var loginRegBar: UISegmentedControl!
    
    @IBAction func handleLoginRegBarChange(_ sender: Any) {
        let title = loginRegBar.titleForSegment(at: loginRegBar.selectedSegmentIndex)
        
        userNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        passwordConfTextField.text = ""
        
        userNameTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor?.isActive = false
        passwordConfTextFieldHeightAnchor?.isActive = false


        if title == "Login" {
            loginButton.isHidden = false
            loginButton.isEnabled = true
            registerButton.isHidden = true
            registerButton.isEnabled = false
            
            inputsContainerViewHeightAnchor?.constant = 100
            
            userNameTextFieldHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
            
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            
            passwordConfTextFieldHeightAnchor = passwordConfTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        }
        else {
            loginButton.isHidden = true
            loginButton.isEnabled = false
            registerButton.isHidden = false
            registerButton.isEnabled = true
            
            inputsContainerViewHeightAnchor?.constant = 200
            
            userNameTextFieldHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
            
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
            
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
            
            passwordConfTextFieldHeightAnchor = passwordConfTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        }
        userNameTextFieldHeightAnchor?.isActive = true
        emailTextFieldHeightAnchor?.isActive = true
        passwordTextFieldHeightAnchor?.isActive = true
        passwordConfTextFieldHeightAnchor?.isActive = true

    }
    
    var inputsContainerViewHeightAnchor : NSLayoutConstraint?
    var userNameTextFieldHeightAnchor : NSLayoutConstraint?
    var emailTextFieldHeightAnchor : NSLayoutConstraint?
    var passwordTextFieldHeightAnchor : NSLayoutConstraint?
    var passwordConfTextFieldHeightAnchor : NSLayoutConstraint?
    
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let userNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordConfTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        let sideGapSize : CGFloat = -24
       // setupTitleBox(sideGapSize: sideGapSize)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "1.jpeg")!)
          var imageView : UIImageView
          imageView  = UIImageView(frame:CGRect(x: 10, y: 200, width: 400, height: 50));
          imageView.image = UIImage(named:"JigsawText.png")
          self.view.addSubview(imageView)
        setupLoginRegBar()
        setupInputsContainerView(sideGapSize: sideGapSize)
        setupLoginAndRegButton(sideGapSize: sideGapSize)
        setupGuestButton(sideGapSize: sideGapSize)
        setupActivityIndicator()
        UIViewPropertyAnimator(duration: 1.25, curve: .easeIn, animations: {
            self.registerButton.alpha = 1.0
            self.inputsContainerView.alpha = 1.0
            self.loginRegBar.alpha = 1.0
            self.guestButton.alpha = 1.0
  //          self.titleBox.alpha = 1.0
        }).startAnimation()
        
    
        // Do any additional setup after loading the view.
    }
    
    func setupTitleBox(sideGapSize: CGFloat) {
        titleBox.backgroundColor = .clear
        titleBox.translatesAutoresizingMaskIntoConstraints = false
        titleBox.text = "Welcome to Jigsaw"
        titleBox.textAlignment = .center
        titleBox.textColor = .white
        titleBox.font = UIFont.systemFont(ofSize: 40)
        titleBox.layer.cornerRadius = 10

        
        titleBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 100 ).isActive = true
        titleBox.widthAnchor.constraint(equalTo: view.widthAnchor, constant: sideGapSize).isActive = true
        titleBox.heightAnchor.constraint(equalToConstant: 80).isActive = true
        titleBox.alpha = 0.0
    }
    
    func setupLoginRegBar() {
        loginRegBar.setTitle("Register", forSegmentAt: 0)
        loginRegBar.setTitle("Login", forSegmentAt: 1)
        loginRegBar.translatesAutoresizingMaskIntoConstraints = false
        loginRegBar.tintColor = .white
        
        loginRegBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegBar.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegBar.widthAnchor.constraint(equalTo: view.widthAnchor,  multiplier: 0.5).isActive = true
        loginRegBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        loginRegBar.alpha = 0.0
    }
    
    func setupInputsContainerView(sideGapSize: CGFloat) {
        //need x, y, width, height constraints
        
        inputsContainerView.backgroundColor = UIColor.white
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.layer.borderColor = UIColor.red.cgColor
        inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.layer.masksToBounds = true
                
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: sideGapSize).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 200)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(userNameTextField)
        inputsContainerView.addSubview(userNameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(passwordConfTextField)
        
        //need x, y, width, height constraints
        userNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        userNameTextFieldHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        userNameTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        userNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        userNameSeparatorView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        userNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        userNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordConfTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordConfTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordConfTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordConfTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordConfTextFieldHeightAnchor?.isActive = true
        
        inputsContainerView.alpha = 0.0
    }
    
    func setupLoginAndRegButton(sideGapSize: CGFloat) {
        loginButton.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha:1)
        loginButton.setTitle("Login", for: UIControl.State())
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitleColor(UIColor.white, for: UIControl.State())
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: sideGapSize).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        registerButton.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha:1)
        registerButton.setTitle("Register", for: UIControl.State())
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitleColor(UIColor.white, for: UIControl.State())
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: sideGapSize).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.alpha = 0.0
        
        
        loginButton.isEnabled = false
        loginButton.isHidden = true
        
    }
    
    func setupGuestButton(sideGapSize: CGFloat) {
        guestButton.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha:1)
        guestButton.setTitle("Play As Guest", for: UIControl.State())
        guestButton.translatesAutoresizingMaskIntoConstraints = false
        guestButton.setTitleColor(UIColor.white, for: UIControl.State())
        guestButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        guestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12).isActive = true
        guestButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: sideGapSize).isActive = true
        guestButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        guestButton.alpha = 0.0
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showAlert(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func unwindToWelcome(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        
        do {
            guard let user = Auth.auth().currentUser else {
                
                return
            }
            if user.isAnonymous {
                user.delete { error in
                    if let error = error {
                      // An error happened.
                      print(error)
                    }
                }
            }
            try
            Auth.auth().signOut()

            userNameTextField.text = ""
            emailTextField.text = ""
            passwordTextField.text = ""
            passwordConfTextField.text = ""
            
        } catch let error {
            print(error)
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
}

