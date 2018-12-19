//
//  MessageViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/19.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController {
    var firebase = FirebaseCommunicator.shared
    var time = ""
    var star = 0
    var inside = true
    var finalmessage = Message()
    var object = [Message]()
    
    @IBOutlet weak var message: UITextField!
    
    @IBOutlet weak var ordertime: UILabel!
    
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        load()
    }
    
   
    
    @IBAction func send(_ sender: UIButton) {
        update()
    }
    @IBOutlet weak var managermessage: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        load()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func starslider(_ sender: UISlider) {
        
        switch sender.value as! Int {
        case 1:
            self.onestar.image = UIImage(named: "star")
            break
        case 2:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            break
        case 3:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "star")
            break
        case 4:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "star")
            self.forstar.image = UIImage(named: "star")
            break
        case 5:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "star")
            self.forstar.image = UIImage(named: "star")
            self.fifstar.image = UIImage(named: "star")
            break
        default:
            self.onestar.image = UIImage(named: "restar")
            self.twostar.image = UIImage(named: "restar")
            self.thirdstar.image = UIImage(named: "restar")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            break
        }
    }
    
    @IBOutlet weak var onestar: UIImageView!
    
    @IBOutlet weak var fifstar: UIImageView!
    @IBOutlet weak var forstar: UIImageView!
    @IBOutlet weak var thirdstar: UIImageView!
    @IBOutlet weak var twostar: UIImageView!
    func load() {
        ordertime.text = self.time
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        firebase.loadData(collectionName: "message", documentName: currentUser.uid) { (result, error) in
            if let error = error {
                print("error :\(error)")
            }
            let total = result as! [String:Any]
            self.finalmessage.manager = total["manager"] as? String ?? ""
            self.finalmessage.star = total["star"] as? Int ?? 0
            self.finalmessage.visitor = total["visitor"] as? String ?? ""
            self.finalmessage.time = self.time
            
            self.object.append(self.finalmessage)
            
            self.managermessage.text = self.finalmessage.manager
            self.message.text = self.finalmessage.visitor
            let finialstar = self.finalmessage.star
            switch finialstar {
            case 1:
                self.onestar.image = UIImage(named: "star")
                break
            case 2:
                self.onestar.image = UIImage(named: "star")
                self.twostar.image = UIImage(named: "star")
                break
            case 3:
                self.onestar.image = UIImage(named: "star")
                self.twostar.image = UIImage(named: "star")
                self.thirdstar.image = UIImage(named: "star")
                break
            case 4:
                self.onestar.image = UIImage(named: "star")
                self.twostar.image = UIImage(named: "star")
                self.thirdstar.image = UIImage(named: "star")
                self.forstar.image = UIImage(named: "star")
                break
            case 5:
                self.onestar.image = UIImage(named: "star")
                self.twostar.image = UIImage(named: "star")
                self.thirdstar.image = UIImage(named: "star")
                self.forstar.image = UIImage(named: "star")
                self.fifstar.image = UIImage(named: "star")
                break
            default:
                self.onestar.image = UIImage(named: "restar")
                self.twostar.image = UIImage(named: "restar")
                self.thirdstar.image = UIImage(named: "restar")
                self.forstar.image = UIImage(named: "restar")
                self.fifstar.image = UIImage(named: "restar")
                break
            }
            
        }
    }
    
    
   
    
    
    func update() {
        print("star: \(self.star)")
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let data:[String:Any] = [ "manager":"", "star":self.star, "time":self.time ,"visitor":message.text ?? "" ]
        firebase.addData(collectionName: "message", documentName: currentUser.uid, data: data) { (result, error) in
            if let error = error {
                print("error : \(error)")
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
