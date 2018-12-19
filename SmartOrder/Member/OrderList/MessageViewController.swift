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
    var finialtimes = ""
    var star = 0
    var inside = true
    var finalmessage = Message()
    var object = [Message]()
    var reobject = [Message]()
    var keys = ""
    
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var managermessage: UITextView!
    @IBOutlet weak var ordertime: UILabel!
    
    
   
    
   
    
    @IBAction func send(_ sender: UIButton) {
        let alert = UIAlertController(title: "確定發送", message: "確定發送訊息", preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default) { (UIAlertAction) in
            self.update(upkeys: self.keys)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        ordertime.text = self.time
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func starslider(_ sender: UISlider) {
        let value = Int(sender.value)
        
        switch value {
        case 0 :
            self.onestar.image = UIImage(named: "restar")
            self.twostar.image = UIImage(named: "restar")
            self.thirdstar.image = UIImage(named: "restar")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            star = 0
            break
        case 1 :
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "restar")
            self.thirdstar.image = UIImage(named: "restar")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            star = 1
            break
        case 2:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "restar")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            star = 2

            break
        case 3:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "star")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            star = 3

            break
        case 4:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "star")
            self.forstar.image = UIImage(named: "star")
            self.fifstar.image = UIImage(named: "restar")
            star = 4

            break
        case 5:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "star")
            self.forstar.image = UIImage(named: "star")
            self.fifstar.image = UIImage(named: "star")
            star = 5

            break
        default:
            self.onestar.image = UIImage(named: "restar")
            self.twostar.image = UIImage(named: "restar")
            self.thirdstar.image = UIImage(named: "restar")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            star = 0

            break
        }
    }
    
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        viewDidLoad()
        viewWillAppear(true)
    }
    
    @IBOutlet weak var onestar: UIImageView!
    
    @IBOutlet weak var fifstar: UIImageView!
    @IBOutlet weak var forstar: UIImageView!
    @IBOutlet weak var thirdstar: UIImageView!
    @IBOutlet weak var twostar: UIImageView!
    
    
    func load() {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        firebase.loadData(collectionName: "message") { (result, error) in
            if let error = error {
                print("error :\(error)")
            }
            let finial = result as! [String:[String:Any]]
            _ = finial.forEach({ (key, value) in
                print("revalue: \(value)")
                let uid = value["uid"] as? String ?? ""
                let times = value["time"] as? String ?? ""
                print("uid: \(uid) ,times: \(times)")
                if uid == currentUser.uid && times == self.time {
                    self.keys = key
                    self.finialtimes = times
                    self.finalmessage.email = value["name"] as? String ?? ""
                    self.finalmessage.manager = value["manager"] as? String ?? ""
                    self.finalmessage.star = value["star"] as? Int ?? 0
                    self.finalmessage.visitor = value["visitor"] as? String ?? ""
                    self.star = self.finalmessage.star
                    self.message.text = self.finalmessage.visitor
                    self.managermessage.text = self.finalmessage.manager
                    self.starcount(finialstar: self.finalmessage.star)
                    self.ordertime.text = times
                    print("reobject: \(self.reobject)")
                    
                }
            })
        }
        print("load successful")
    }
    func starcount(finialstar:Int) {
        switch finialstar {
        case 0 :
            self.onestar.image = UIImage(named: "restar")
            self.twostar.image = UIImage(named: "restar")
            self.thirdstar.image = UIImage(named: "restar")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            
            break
        case 1 :
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "restar")
            self.thirdstar.image = UIImage(named: "restar")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            
            break
        case 2:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "restar")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            
            
            break
        case 3:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "star")
            self.forstar.image = UIImage(named: "restar")
            self.fifstar.image = UIImage(named: "restar")
            
            
            break
        case 4:
            self.onestar.image = UIImage(named: "star")
            self.twostar.image = UIImage(named: "star")
            self.thirdstar.image = UIImage(named: "star")
            self.forstar.image = UIImage(named: "star")
            self.fifstar.image = UIImage(named: "restar")
            
            
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
    
    
   
    
    
    func update(upkeys: String) {
        print("star: \(self.star)")
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let data1:[String:Any] = [ "manager":self.managermessage.text ?? "", "star":self.star ,"visitor":message.text ?? ""]
        let data2:[String:Any] = [ "manager":self.managermessage.text ?? "", "star":self.star, "time":self.time ,"visitor":message.text ?? "" ,"name":currentUser.email ?? currentUser.displayName ?? "","uid":currentUser.uid]
        if keys == upkeys && finialtimes == self.time{
            print("update data")
            firebase.updateData(collectionName: "message", documentName: keys, data: data1) { (result, error) in
                if let error = error {
                    print("error : \(error)")
                }
                
            }
            self.keys = ""
            self.finialtimes = ""
            self.star = 0
        }else {
            print("add data")
            firebase.addData(collectionName: "message", documentName: nil, data: data2) { (result, error) in
                if let error = error {
                    print("error : \(error)")
                }
             }
            self.star = 0
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
