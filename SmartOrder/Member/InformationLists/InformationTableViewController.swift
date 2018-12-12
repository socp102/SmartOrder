//
//  InformationTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase


class InformationTableViewController: UITableViewController {
    
    let fireBase = FirebaseCommunicator.shared
    var objects = [Information]()
    var information = Information()
    var loadinfo = ["":""]
    
    
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.isScrollEnabled = false
        loadinfonum()
        
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
                self.loadinfo = result as! [String : String]
                print("loadinfo : \(self.loadinfo)")
                self.information.birthday = self.loadinfo["Birthday"] ?? ""
                self.information.email = self.loadinfo["email"]!
                self.information.phoneNum = self.loadinfo["PhoneNumber"] ?? ""
                self.information.gender = self.loadinfo["Gender"] ?? ""
                self.information.name = self.loadinfo["name"] ?? ""
                self.email.text = self.information.email
                self.name.text = self.information.name
                self.birthday.text = self.information.birthday
                self.phone.text = self.information.phoneNum
                self.objects.append(self.information)
                }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is modifyTableViewController {
            let controller = segue.destination as! modifyTableViewController
                let detialobject = self.objects
            controller.objects = detialobject
            print("o:\(self.objects)")
        }
    }

}
