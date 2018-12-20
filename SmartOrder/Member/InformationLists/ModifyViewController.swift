//
//  ModifyViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/13.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class ModifyViewController: UIViewController {
    
    let fireBase = FirebaseCommunicator.shared
    var objects = [Information]()
    var information = Information()
    var reobjects = [Information]()
    var reinformation = Information()
    var info:[String:Any] = ["":1]
    let formatter = DateFormatter()
    var iskeyboardHidden = true
    var selectedTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if sex.isOn {
            sextext.text = "Male"
        } else {
            sextext.text = "Female"
        }
        loadinfonum()
        
        name.delegate = self as UITextFieldDelegate
        phone.delegate = self as UITextFieldDelegate
        
        registerNotification()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func gender(_ sender: Any) {
        if sex.isOn {
            sextext.text = "Male"
        } else {
            sextext.text = "Female"
        }
    }
    //鍵盤
    func registerNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @IBOutlet weak var containtView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            guard let frame = selectedTextField?.frame else {
                print("frame is nil")
                return }
            let offset = frame.origin.y + stackView.frame.origin.y + containtView.frame.origin.y + 36 - (self.view.frame.size.height - keyboardFrame.height)
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
    
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        iskeyboardHidden = false
    }
    
    
    @objc
    func keyboardWillHidden(notification: NSNotification) {
        iskeyboardHidden = true
    }
    
    // MARK: 取消監聽鍵盤
    func releaseNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var sex: UISwitch!
    @IBOutlet weak var sextext: UILabel!
    
    
    @IBAction func finalBtn(_ sender: UIButton) {
        
        
        reinformation.name = name.text ?? information.name
        reinformation.phoneNum = phone.text ?? information.phoneNum
        print("birdate: \(date.date)")
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd"
        let customDate = dateformatter.string(from: date.date)
        reinformation.birthday = customDate
        
        if sex.isOn {
            sextext.text = "Male"
            reinformation.gender = "1"
        }else{
            sextext.text = "FeMale"
            reinformation.gender = "2"
        }
            reobjects.append(reinformation)
            print("reobject: \(reobjects)")
        let alert = UIAlertController(title: "確定發送", message: "確定發送訊息", preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default) { (UIAlertAction) in
            self.modify()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
 
    
    func modify() {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("uid fail")
            return
        }
        for datas in reobjects{
            print("data: \(datas)")
            
            let data = [["name":datas.name],["PhoneNumber":datas.phoneNum],["Gender":datas.gender],["Birthday":datas.birthday]]
            
            for infos in 0...3 {
                print("datainfo: \(data[infos])")
                fireBase.updateData(collectionName: "account", documentName: currentUserUid, data: data[infos]) { (results, error) in
                    if let error = error {
                        print("error: \(error)")
                    }
                }
            }
        }
        
    }
    
    
    
    func loadinfonum() {
        //下載
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("uid fail")
            return
        }
        fireBase.loadData(collectionName: "account", documentName: currentUserUid) { (result, error) in
            if let error = error {
                print("error: \(error)")
            }else{
                let result = result as! [String:Any]
                self.info = result
                print("loadinfo : \(self.info)")
                self.information.birthday = self.info["Birthday"] as? String ?? ""
        //self.information.email = self.info["email"] as? String ?? ""
                self.information.phoneNum = self.info["PhoneNumber"] as? String ?? ""
                self.information.gender = self.info["Gender"] as? String ?? ""
                self.information.name = self.info["name"] as? String ?? ""
                self.objects.append(self.information)
                
                
                
               // self.mail.text = self.information.email
                self.name.text = self.information.name
                self.phone.text = self.information.phoneNum
                if self.information.gender == "1" {
                    self.sex.isOn = true
                    self.sextext.text = "Male"
                }else if self.information.gender == "2" {
                    self.sex.isOn = false
                    self.sextext.text = "Female"
                }
                
                let birthday = self.information.birthday
                if birthday != ""{
                    print("bir: \(birthday)")
                    self.formatter.dateFormat = "yyyy/MM/dd"
                    let date = self.formatter.date(from: birthday)
                    self.date.date = date!
                }
                
                
                
            }
            
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

extension ModifyViewController: UITextFieldDelegate {
    
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
