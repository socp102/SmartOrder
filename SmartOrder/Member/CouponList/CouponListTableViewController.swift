//
//  CouponListTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/11/28.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

struct coupon {
    var title = ""
    var imagename = ""
    var couponQty = 0
    var couponValidDate = ""
    var couponDiscount = 0.0
    var couponDetilContent = ""

}

class CouponListTableViewController: UITableViewController {

    
    var firebaseCommunicator = FirebaseCommunicator.shared
    var couponInfo : [String:[String:Any]] = ["":["":0]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    //cell 資料設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "couponlist", for: indexPath)
        
        cell.textLabel?.text = title
        return cell
    }
    
    func getCouponInfo() {
        //抓優惠卷資料
        firebaseCommunicator.loadData(collectionName: "couponInfo") { (result, error) in
            if let error = error {
                print("error:\(error)")
            } else {
                
                self.couponInfo = result as! [String:[String:Any]]
                
                let couponCollection = ["001","002","003"]
                
                for reviewCoupon in  couponCollection {
                    
                    var couponReview = self.couponInfo["\(reviewCoupon)"]
                    let couponOwner = couponReview?["owner"]
                    let couponOwnerNSDictionary = couponOwner as? NSDictionary
                    let couponDictionaryOptional = couponOwnerNSDictionary as? Dictionary<String, Any>
                    let couponOwnerDictionary = couponDictionaryOptional!
                    
                    let hasCoupon = couponOwnerDictionary.keys.contains(self.user!)
                    
                    //使用者有在該優惠卷裡面
                    if hasCoupon == true   {
                        
                        let userCouponValueAny = couponOwnerDictionary[self.user!]
                        let userCouponValueInt = userCouponValueAny as! Int
                        
                        //領取但還沒用過
                        if userCouponValueInt == 0 {
                            
                            
                            //領取但已使用過
                        }else if userCouponValueInt == 1 {
                            
                            self.couponInfo.removeValue(forKey: "\(reviewCoupon)")
                            
                        }
                        
                    } else if hasCoupon == false  {
                        
                        self.couponInfo.removeValue(forKey: "\(reviewCoupon)")
                        
                    }
                }
                
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
