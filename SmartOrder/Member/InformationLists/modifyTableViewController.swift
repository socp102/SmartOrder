//
//  modifyTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class modifyTableViewController: UITableViewController {
    let fireBase = FirebaseCommunicator.shared
    var objects = [Information]()
    var information = Information()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        
    }
    
    @IBAction func finalBtn(_ sender: UIButton) {
        objects.append(information)
        print("object: \(objects)")
    }
    
    
    @IBAction func emailtextField(_ sender: UITextField) {
        guard let email = sender.text else {
            return
        }
        information.email = email
    }
    
    @IBAction func nameTextField(_ sender: UITextField) {
        guard let name = sender.text else {
            return
        }
        information.name = name
        
    }
    
    @IBAction func Gender(_ sender: UISwitch) {
        if sender.isOn {
            information.gender = "1"
        } else {
            information.gender = "2"
        }
        
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
    }
    
    @IBAction func phoneTextField(_ sender: UITextField) {
        guard let phone = sender.text else {
            return
        }
        information.phoneNum = phone
        
    }
    
    func modify() {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("uid fail")
            return
        }
        /*
        fireBase.updateData(collectionName: "account", documentName: currentUserUid, data: data) { (results, error) in
            if let error = error {
                print("error: \(error)")
            }
        }
         */
        
    }
}
