//
//  OrderListTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/11/28.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class OrderListTableViewController: UITableViewController {

    
    var orderinfo : [String:Any] = [ "" : 0 ]
    var object = Order()
    var objects = [Order]()
    
    var firebaseCommunicator = FirebaseCommunicator.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshdata()
        
    }
    
    func refreshdata(){
        objects.removeAll()
        object.itemName.name.removeAll()
        object.itemName.detialitem.count.removeAll()
        object.itemName.detialitem.subtotle.removeAll()
        object.total.removeAll()
        object.coupon.removeAll()
        object.time.removeAll()
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        getCouponInfo(user: currentUser.uid)
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objects.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = objects[section]
        
        let result = item.time
        
        return result
    }
   
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "ordercell", for: indexPath)
        let item = objects[indexPath.section]
        cell.detailTextLabel?.text = "$ \(item.total) 元"
        cell.tag = indexPath.section
        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "删除") {
            action, index in
            //将对应条目的数据删除
            //self.items.remove(at: index.row)
            tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
 */
    //下載資料
    
    func getCouponInfo(user: String) {
        firebaseCommunicator.loadData(collectionName: "order", field: "userID", condition: user) { (result, error) in
            
            if let error = error {
                print("error:\(error)")
            }
            var keys = ""
            var info = result as! [String:Any]
            info.forEach({ (key, value) in
                keys = key
                self.orderinfo = info[keys] as! [String : Any]
                //總額
                self.object.total = (self.orderinfo["total"])! as! String
                //date
                let FIRServerValue = (self.orderinfo["timestamp"])! as! Timestamp
                
                //print("FIRServerValue: \(FIRServerValue)")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
                let orderTime = Double(FIRServerValue.seconds)
                let date = dateFormatter.string(from: Date(timeIntervalSince1970: orderTime))
                self.object.time = date
                
                //第三層
                let orderitem = (self.orderinfo["allOrder"])! as! [String:[String:Any]]
                
                //如果不使用優惠券
                guard self.orderinfo["coupon"] != nil else {
                    self.object.itemName.name.removeAll()
                    self.object.itemName.detialitem.count.removeAll()
                    self.object.itemName.detialitem.subtotle.removeAll()
                    
                    for item in orderitem.keys {
                        self.object.itemName.name.append(item)
                        let detialitem = orderitem[item]
                        self.object.itemName.detialitem.count.append((detialitem!["count"]!) as! String)
                        self.object.itemName.detialitem.subtotle.append((detialitem!["subtotal"]!) as! String)
                        
                    }
                    
                    self.objects.append(self.object)
                    print("objects: \(self.objects)")
                    self.tableView.reloadData()
                    return
                }
                self.object.coupon = (self.orderinfo["coupon"])! as! String
                
                //明細
                self.object.itemName.name.removeAll()
                self.object.itemName.detialitem.count.removeAll()
                self.object.itemName.detialitem.subtotle.removeAll()
                
                for item in orderitem.keys {
                    
                    self.object.itemName.name.append(item)
                    let detialitem = orderitem[item]
                    self.object.itemName.detialitem.count.append((detialitem!["count"]!) as! String)
                    self.object.itemName.detialitem.subtotle.append((detialitem!["subtotal"]!) as! String)
                   
                }
                
                //上傳
                
                self.objects.append(self.object)
                print("object: \(self.objects)")
                self.tableView.reloadData()
            })

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ordersegue" {
            let controller = segue.destination as! OrderListDetialTableViewController
//            let detialobject = self.objects
//            controller.detialobject = detialobject
            let index = sender as! UITableViewCell
            let courseSelect = objects[index.tag]
            print("tag: \(index.tag)")
            controller.detialobject = courseSelect
        }
    }
    
    
    
}
