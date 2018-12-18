//
//  OrderListDetialTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class OrderListDetialTableViewController: UITableViewController {
    let communicator = FirebaseCommunicator.shared
    var detialobject = Order()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setvalue()
    }
    @IBOutlet weak var detialtime: UILabel!
    @IBOutlet weak var detialItem: UITextView!
    
    @IBOutlet weak var couponDetial: UILabel!
    @IBOutlet weak var finialtotal: UILabel!
  
    // MARK: - Table view data source

    
    func setvalue() {
        
        var name = self.detialobject.itemName.name
        var count = self.detialobject.itemName.detialitem.count
        var subtotle = self.detialobject.itemName.detialitem.subtotle
        
        //let items:Int = self.detialobject.itemName.name.count
        var totalitem:String = ""
        for i in 0 ..< count.count {
            print("i: \(i)")
            let item = " 品名 ：\(name[i]) 數量: \(count[i]) 單價：\(subtotle[i]) \n"
            totalitem += item
            print("item : \(item)")
            
        }
        print("totalitem: \(totalitem)")
        detialItem.text = totalitem
        detialtime.text = self.detialobject.time
        finialtotal.text = "折扣後金額： \(self.detialobject.total) 元"
        couponDetial.text = self.detialobject.coupon
        
        
    }
    
}
