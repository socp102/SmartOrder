//
//  MainViewController.swift
//  SmartOrder
//
//  Created by Eason on 2018/11/4.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Add the background gradient  背景調成漸層色
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //監聽登入狀態
        checkSignInState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authHandle!)
        
    }
    
    // Signup 註冊
    func signUp (email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                print("Fail to signUp: \(error.localizedDescription)")
            }
            print("Success signUp : \(String(describing: result?.user))")
        }
    }
    
    // SignIn 登入
    func signIn (email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Fail to signIn: \(error)")
            }
            guard let user = user else { return }
            print("Success signIn: \(user)")
//            self.performSegue(withIdentifier: "segueToUser", sender: self)
            self.checkSignInState()
        }
    }
    
    // Check SignIn State
    
    func checkSignInState() {
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let email = user?.email {
                if email == "admin@test.com" {
                    self.performSegue(withIdentifier: "segueToAdmin", sender: self)
                } else {
                    self.performSegue(withIdentifier: "segueToUser", sender: self)
                }
            }
        }
    }
    

    @IBAction func BtnPressedSignin(_ sender: Any) {
        guard let email = textFieldEmail.text, let password = textFieldPassword.text else {
            print("Email or Password is nil")
            return
        }
        signIn(email: email, password: password)
        
    }
    
    // 測試用快速登入店長或會員帳號
    @IBAction func signInAdmin(_ sender: Any) {
        signIn(email: "admin@test.com", password: "123456")
    }
    
    @IBAction func signInUser(_ sender: Any) {
        signIn(email: "user@test.com", password: "123456")
    }
    
}
