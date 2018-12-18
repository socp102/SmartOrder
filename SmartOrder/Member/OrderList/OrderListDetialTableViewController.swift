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
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var couponDetial: UILabel!
    @IBOutlet weak var finialtotal: UILabel!
  
    // MARK: - Table view data source

    
    func setvalue() {
       
        for _ in self.detialobject.itemName.name {
            detialItem.text.append(contentsOf:"\(self.detialobject.itemName.name)  數量：\(self.detialobject.itemName.detialitem.count) 總額：\(self.detialobject.itemName.detialitem.subtotle)" )
            
        }
        
        detialtime.text = self.detialobject.time
        finialtotal.text = "折扣後金額： \(self.detialobject.total) 元"
        couponDetial.text = self.detialobject.coupon
    }
    
}
