//
//  StarDetialViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/19.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class StarDetialViewController: UIViewController {
    var detialobject = Message()
    var firebase = FirebaseCommunicator.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func send(_ sender: UIButton) {
        var text = ManagerTextField.text
        let alert = UIAlertController(title: "確定發送", message: "確定發送訊息", preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default) { (UIAlertAction) in
            let data:[String:Any] = ["manager":text]
            self.firebase.updateData(collectionName: "message", documentName: self.detialobject.uid, data: data) { (result, error) in
                if let error = error {
                    print("error: \(error)")
                }
            }
            self.viewWillAppear(true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var ManagerTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        update()
    }
    
    func update() {
        time.text = detialobject.time
        name.text = detialobject.email
        star.text = "\(detialobject.star) 顆星"
        message.text = detialobject.visitor
        ManagerTextField.text = detialobject.manager
    }
    
}
