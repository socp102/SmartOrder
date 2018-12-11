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

    var photo:UIImage? = nil
    var id = ""
    let communicator = FirebaseCommunicator.shared
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "signOutSegue", sender: nil)
        } catch let signOutErroe as NSError {
            print("Error signing out: %$", signOutErroe)
        }
    
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
    @IBOutlet weak var Photos: UIImageView!
    @IBOutlet weak var Id: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderlistView.isHidden = false
        CouponView.isHidden = true
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        photo = update(currentUserUid: currentUser)
        id = currentUser.email!
        Id.text = id
    }
    
    func update(currentUserUid: User)->UIImage{
        var pho:UIImage? = nil
        //下載照片
        communicator.downloadImage(url: "AppCodaFireUpload/", fileName: "\(currentUserUid.uid).jpeg") { (result, error) in
            if let error = error {
                print("download photo error:\(error)")
                
            } else {
                self.Photos.image = (result as! UIImage)
                pho = (result as! UIImage)
            }
            
        }
        
 
        return pho!
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MemberViewController {
            let controller = segue.destination as! MemberViewController
            let photo = self.photo
            let id = self.id
            controller.photo = photo
            controller.id = id
            
        }
    }
}

