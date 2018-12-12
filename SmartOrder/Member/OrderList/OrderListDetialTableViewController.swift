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
    let get = Getphoto()
    override func viewDidLoad() {
        super.viewDidLoad()
        setvalue()
        Photos.image = get.update()
        Id.text = get.currentUsermail
    }
    @IBOutlet weak var detialtime: UILabel!
    @IBOutlet weak var detialItem: UITextView!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var couponDetial: UILabel!
    @IBOutlet weak var finialtotal: UILabel!
    @IBOutlet weak var Photos: UIImageView!
    @IBOutlet weak var Id: UILabel!
    // MARK: - Table view data source

    
    func setvalue() {
        detialtime.text = self.detialobject.time
        detialItem.text = "\(self.detialobject.itemName.name)  數量：\(self.detialobject.itemName.detialitem.count)"
        total.text = self.detialobject.itemName.detialitem.subtotle
        finialtotal.text = "折扣後金額： \(self.detialobject.total) 元"
        couponDetial.text = self.detialobject.coupon
    }
    
}
