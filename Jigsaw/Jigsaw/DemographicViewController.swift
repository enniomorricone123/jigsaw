//
//  DemographicViewController.swift
//  Jigsaw
//
//  Created by Grant Larson on 10/27/19.
//  Copyright © 2019 ECE564. All rights reserved.
//

import UIKit
import Firebase

class DemographicViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
  
//    lazy var datePicker: UIDatePicker = {
//        let picker = UIDatePicker()
//        picker.datePickerMode = .date
//        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
//        return picker
//    }()
//
//    lazy var dateFormatter: DateFormatter = {
//           let formatter = DateFormatter()
//           formatter.dateStyle = .medium
//           formatter.timeStyle = .none
//           return formatter
//       }()
//
    
    private var politicalPicker: UIPickerView?
    private var genderPicker: UIPickerView?
    private var agePicker: UIPickerView?

    private var genderPickerOption = ["Male", "Female", "Non-binary", "Prefer not to say"]
    private var politicalPickerOption = ["Democratic","Republican","others","Don't want to disclose"]
    private var agePickerOption = ["18-25","25-35","35+","Don't want to disclose"]
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
//  race
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var religionTextField: UITextField!
    @IBOutlet weak var politicalTextField: UITextField!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var saveInfo: UIBarButtonItem!
    
    @IBAction func storeDatabase(_ sender: Any) {
        let currentuser : String? = Auth.auth().currentUser?.uid;            Database.database().reference().child("users").child(currentuser!).child("religion").setValue(religionTextField.text ?? "Not chosen")
        Database.database().reference().child("users").child(currentuser!).child("gender").setValue(genderTextField.text ?? "Not chosen")
        Database.database().reference().child("users").child(currentuser!).child("political").setValue(politicalTextField.text ?? "Not chosen")
        Database.database().reference().child("users").child(currentuser!).child("age").setValue(ageTextField.text ?? "Not chosen")
        Database.database().reference().child("users").child(currentuser!).child("name").setValue(nameTextField.text ?? "Not chosen")

    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
            guard let user = Auth.auth().currentUser else{
                print("Not logged in?")
                return
            }
            let uid = user.uid

            user.delete { error in
              if let error = error {
                // An error happened.
                print(error)
              }
              else {
                let ref = Database.database().reference(fromURL: "https://jigsaw-25200.firebaseio.com/")
                let usersRef = ref.child("users").child(uid)
                usersRef.removeValue()
                self.dismiss(animated: true, completion: {})
              }
            }
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(delete)
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDeleteButton()
        loadPicker()
        setdelegate()
        loadData()
        // dismiss the keyboard
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
       
        
    }

    func loadData(){
        let textfields = [nameTextField, genderTextField, ageTextField, religionTextField, politicalTextField]
        let databaseStrings = ["name" ,"gender", "age", "religion", "political"]
        let currentuser : String? = Auth.auth().currentUser?.uid;
        for i in 0...databaseStrings.count-1 {
            Database.database().reference().child("users").child(currentuser!).child(databaseStrings[i]).observeSingleEvent(of: .value, with: { (snapshot) in
                   let string_value = snapshot.value as? NSString
                   if (string_value != nil) {
                    textfields[i]!.text = String(string_value!)
                   }
                
               }) { (error) in
                      print(error.localizedDescription)
                  }
        }

    }
    
    
    func setUpDeleteButton() {
        deleteAccountButton.setTitleColor(.red, for: .normal)
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        deleteAccountButton.titleLabel?.alpha = 0.75
        deleteAccountButton.layer.borderColor = UIColor.black.cgColor
        //deleteAccountButton.layer.borderWidth = 1.0
        deleteAccountButton.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha:1)
        
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        deleteAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        
        deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteAccountButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
   //load the picker information
      func loadPicker(){
//          DOBTextField.inputView = datePicker
          politicalPicker = UIPickerView()
          politicalTextField.inputView = politicalPicker
          genderPicker = UIPickerView()
          genderTextField.inputView = genderPicker
          agePicker = UIPickerView()
          ageTextField.inputView = agePicker
      }
      
    //sets the delegate of the textfield as self
    func setdelegate(){
        nameTextField.delegate=self
        politicalTextField.delegate = self
        ageTextField.delegate = self
//        DOBTextField.delegate = self
        religionTextField.delegate = self
        genderTextField.delegate=self
        politicalPicker?.delegate=self
        politicalPicker?.dataSource=self
        genderPicker?.delegate=self
        genderPicker?.dataSource=self
        agePicker?.delegate=self
        agePicker?.dataSource=self
    }
        
    
    
//    //MARK: date picker:
//    @objc func datePickerChanged(_ sender: UIDatePicker) {
//           DOBTextField.text = dateFormatter.string(from: sender.date)
//       }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    
    //MARK: other picker
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          nameTextField.resignFirstResponder()
          genderTextField.resignFirstResponder()
          ageTextField.resignFirstResponder()
//          DOBTextField.resignFirstResponder()
          religionTextField.resignFirstResponder()
          politicalTextField.resignFirstResponder()
          return true
      }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case politicalPicker:
            return politicalPickerOption.count
        case genderPicker:
            return genderPickerOption.count
        default:
            return agePickerOption.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case politicalPicker:
            politicalTextField.text = politicalPickerOption[row]
        case genderPicker:
            genderTextField.text = genderPickerOption[row]
        default://case agePicker:
            ageTextField.text = agePickerOption[row]
        }
        self.politicalTextField.endEditing(false)
    
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case politicalPicker:
            return politicalPickerOption[row]
        case genderPicker:
           return genderPickerOption[row]
        default:
           return agePickerOption[row]
       }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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


