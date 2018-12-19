//
//  ViewController.swift
//  SmartOder
//
//  Created by kimbely on 2018/11/23.
//  Copyright © 2018 kimbely. All rights reserved.
//

import UIKit
import Firebase

class MemberViewController: UIViewController {
    
    let communicator = FirebaseCommunicator.shared
    let get = Getphoto()
    let newaccount = New()
    
    
    @IBAction func signout(_ sender: Any) {
        print("signout")
        let alert = UIAlertController(title: "登出", message: "是否登出此帳號？", preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default) { action in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.performSegue(withIdentifier: "signOutSegue", sender: nil)
                
            } catch let signOutErroe as NSError {
                print("Error signing out: %$", signOutErroe)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .destructive)
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func MembersegmentAction(_ sender: UISegmentedControl) {
        switch MembersegmentedControl.selectedSegmentIndex {
        case 0:
            OrderlistView.isHidden = false
            CouponView.isHidden = true
            
            
        case 1:
            OrderlistView.isHidden = true
            CouponView.isHidden = false
            
        default:
            break
        }
    }
    @IBOutlet weak var MembersegmentedControl: UISegmentedControl!
    @IBOutlet weak var CouponView: UIView!
    @IBOutlet weak var OrderlistView: UIView!
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderlistView.isHidden = false
        CouponView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OrderlistView.isHidden = false
        CouponView.isHidden = true
        
    }
    
}

