//
//  SignUpViewController.swift
//  SmartOrder
//
//  Created by Eason on 2018/12/13.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIPopoverPresentationControllerDelegate, DatePickerViewControllerDelegate {

    var firebase = FirebaseCommunicator.shared
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheackTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var birthdayButton: UIButton!
    var birthday = ""
    var gender = ""
    @IBOutlet weak var stackView: UIStackView!
    var selectedTextField: UITextField?
    var iskeyboardHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Add the background gradient  背景調成漸層色
        view.addVerticalGradientLayer(topColor: secondaryColor , bottomColor: primaryColor)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheackTextField.delegate = self
        nameTextField.delegate = self
        phoneTextField.delegate = self
        
        registerNotification()
    }

    //MARK:監聽鍵盤frame 改變的事件
    func registerNotification(){

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        iskeyboardHidden = false
    }
    
    @objc
    func keyboardWillHidden(notification: NSNotification) {
        iskeyboardHidden = true
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            guard let frame = selectedTextField?.frame else { return }
            let offset = frame.origin.y + stackView.frame.origin.y + 36 - (self.view.frame.size.height - keyboardFrame.height)
            let duration: Double = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                if (offset > 0) && self.iskeyboardHidden {
                    
                    self.view.frame.origin.y -= offset;
                    
                } else {
                    
                    self.view.frame.origin.y = 0;
                    
                }
            })
        }
    }
    
    // MARK: 取消監聽鍵盤
    func releaseNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none  // 轉換頁面忽略設備大小，依照設定顯示
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDatePicker" {
            
            let popoverVC = segue.destination as! DatePickerViewController
            popoverVC.popoverPresentationController?.delegate = self
            popoverVC.delegate = self
            
            let button = sender as! UIButton
            // 調整顯示時對齊Button
            popoverVC.popoverPresentationController?.sourceView = button
            popoverVC.popoverPresentationController?.sourceRect = button.bounds
            
        }
    }
    
//    DatePickerViewControllerDelegate
    func dataSelected(birthday: String) {
        self.birthday = birthday
        birthdayButton.setTitle(birthday, for: .normal)
        }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let passwordCheack = passwordCheackTextField.text,
            let name = nameTextField.text,
            let phone = phoneTextField.text else { return }
        
        if email.isEmpty || password.isEmpty || passwordCheack.isEmpty {
            Common.showAlert(on: self, style: .alert, title: "錯誤", message: "信箱密碼不得為空")
            return
        }
        
        if password != passwordCheack {
            Common.showAlert(on: self, style: .alert, title: "錯誤", message: "請重新確認密碼")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                Common.showAlert(on: self, style: .alert, title: "註冊失敗", message: error.localizedDescription)
                print("Fail to signUp: \(error.localizedDescription)")
            }
            guard let uid = result?.user.uid else {
                print("==========xXXX==========")
                return
            }
            let data = ["email" : email,
                        "Birthday" : self.birthday,
                        "PhoneNumber" : phone,
                        "name" : name,
                        "Gender" : self.gender]
            self.firebase.addData(collectionName: "account", documentName: uid, data: data, completion: { (result, error) in
                if let error = error {
                    print("Fail to addData \(error)")
                    return
                }
                
            })
            print("Success signUp : \(String(describing: result?.user))")
            self.segueToUser()
        }
    }
    
    func segueToUser() {
        self.performSegue(withIdentifier: "segueToUser", sender: self)
    }
    
    @IBAction func genderSegmented(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gender = "0"
        case 1:
            gender = "1"
        case 2:
            gender = "2"
        default:
            gender = "0"
        }
    }
    
    
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedTextField = nil
    }
}
