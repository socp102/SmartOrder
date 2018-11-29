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
    var db: Firestore!
    
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Add the background gradient  背景調成漸層色
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        db = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkSignInState()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        }
    }
    
    // Check SignIn State
    
    func checkSignInState() {
        
        if authHandle != nil {
            Auth.auth().removeStateDidChangeListener(authHandle!)
        }
        
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
    
    // Firestore 測試與範例 ============================================================================
    
    @IBAction func test(_ sender: Any) {
        addNewDocumentGeneratedID()
    }
    
    // 新增資料到 測試用集合 檔名自動生成
    func addNewDocumentGeneratedID() {
        var ref: DocumentReference? = nil
        ref = db.collection("測試用集合").document("1").collection("2").addDocument(data: [
            "key": "值",
            "name": "eason",
            "born": 12345
        ]) { error in
            if let  error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID : \(ref!.documentID)")
            }
        }
    }
    
    // 新增檔案 自訂檔名
    func addNewDocument() {
        db.collection("測試用集合").document("檔案名稱").setData([
            "key": "value",
            "說明": "用set 新增檔案，如果已經存在會覆蓋原本資料"
        ]) { error in
            if let  error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        // 新增檔案 如果已經存在會新增
        db.collection("測試用集合").document("檔案名稱").setData(["新增" : "新增的內容"], merge: true)
    }
    
    // 更新檔案部分內容
    func update() {
        db.collection("測試用集合").document("檔案名稱").updateData([
            "記錄最後更新時間": FieldValue.serverTimestamp()
        ]) { error in
            if let  error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    // 讀取集合內所有檔案
    func loadDatas() {
        db.collection("測試用集合").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) ====> \(document.data())")
                }
            }
        }
    }
    
    // 讀取固定檔案
    func loadDocument() {
        db.collection("測試用集合").document("檔案名稱").getDocument { (document, err) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document odes not exists")
            }
        }
    }
    
    // 讀取符合條件的檔案
    func loadDocumentEqualTo() {
        db.collection("測試用集合").whereField("name", isEqualTo: "eason").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) ====> \(document.data())")
                }
            }
        }
    }
    
}
