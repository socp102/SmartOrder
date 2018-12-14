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
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardtoup()
        if sex.isOn {
            sextext.text = "Male"
        } else {
            sextext.text = "Female"
        }
       loadinfonum()
      self.hideKeyboardWhenTappedAround()
    }
    
    
    
    // 鍵盤調整
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration: Double = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                    frame.origin.y = keyboardFrame.minY - self.view.frame.height - self.tabBarController!.tabBar.frame.height
                self.view.frame = frame
            })
        }
    }
    
    func keyboardtoup() {
    //設定鍵盤輸入時往上移
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var sex: UISwitch!
    @IBOutlet weak var sextext: UILabel!
    
    
    @IBAction func finalBtn(_ sender: UIButton) {
        
        reinformation.email = mail.text ?? information.email
        reinformation.name = name.text ?? information.name
        reinformation.phoneNum = phone.text ?? information.phoneNum
        
        if reinformation.email.isEmpty || reinformation.name.isEmpty || reinformation.phoneNum.isEmpty {
            
            print("mail name phone is nil")
        } else {
            
            
            reobjects.append(reinformation)
            print("reobject: \(reobjects)")
            modify()
        }
        
        
    }
    
 
    
    func modify() {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("uid fail")
            return
        }
        for datas in reobjects{
            print("data: \(datas)")
            let data = [datas.name,datas.phoneNum,datas.gender,datas.birthday,datas.email]
        }
        
        
        /*
         fireBase.updateData(collectionName: "account", documentName: currentUserUid, data: datas) { (results, error) in
         if let error = error {
         print("error: \(error)")
         }
         }
        
        */
        
        
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
                self.information.email = self.info["email"] as? String ?? ""
                self.information.phoneNum = self.info["PhoneNumber"] as? String ?? ""
                self.information.gender = self.info["Gender"] as? String ?? ""
                self.information.name = self.info["name"] as? String ?? ""
                self.objects.append(self.information)
                
                
                
                self.mail.text = self.information.email
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
