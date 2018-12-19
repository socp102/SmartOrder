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
    var totalTime = ""

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
            var finialname = ""
            switch name[i] {
                case "BeefHamburger":
                    finialname = "牛肉漢堡"
                case "ChickenHamburger":
                    finialname = "雞肉漢堡"
                case "PorkHamburger":
                    finialname = "豬肉漢堡"
                case "TomatoSpaghetti":
                    finialname = "紅醬義大利麵"
                case "PestoSpaghetti":
                    finialname = "青醬義大利麵"
                case "CarbonaraSpaghetti":
                    finialname = "白醬義大利麵"
                case "CheesePizza":
                    finialname = "起司披薩"
                case "TomatoPizza":
                    finialname = "番茄披薩"
                case "OlivaPizza":
                    finialname = "橄欖披薩"
                case "FiletMigon":
                    finialname = "牛菲力"
                case "RibeyeSteak":
                    finialname = "牛肋排"
                case "GrilledSteak":
                    finialname = "炙燒牛排"
                case "Macaron":
                    finialname = "馬卡龍"
                case "ChocolateCake":
                    finialname = "巧克力蛋糕"
                case "Sundae":
                    finialname = "聖代"
            default:
                finialname = "unknown"
            }
            let item = " 品名 ：\(finialname) 數量: \(count[i]) 單價：\(subtotle[i]) \n"
            totalitem += item
            print("item : \(item)")
            
        }
        print("totalitem: \(totalitem)")
        detialItem.text = totalitem
        detialtime.text = self.detialobject.time
        finialtotal.text = "折扣後金額： \(self.detialobject.total) 元"
        couponDetial.text = self.detialobject.coupon
        totalTime = self.detialobject.time
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesegue" {
            let controller = segue.destination as! MessageViewController
            let time = self.totalTime
            controller.time = time
        }
    }
}
