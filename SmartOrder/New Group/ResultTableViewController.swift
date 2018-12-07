//
//  ResultTableViewController.swift
//  SmartOrder
//
//  Created by Lu Kevin on 2018/11/20.
//  Copyright © 2018年 Eason. All rights reserved.
//

import UIKit
import Firebase


class ResultTableViewController: UITableViewController {
    let myUserDefaults = UserDefaults.standard
    var addDict =  [String: [String:String]]()
    @IBOutlet weak var totalPriceLabel: UILabel!
    var firebaseCommunicator = FirebaseCommunicator.shared
    
    @IBAction func resultCloseBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func sendOrderToFirebase(_ sender: Any) {
        
        let data = addDict as [String:Any]
        firebaseCommunicator.addData(collectionName: "order", documentName: "0001", data: data) { (result, error) in
            if let error = error {

                print("error:\(error)")
            }
        }
        
        
        
        myUserDefaults.removeObject(forKey: "resultDict")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("Hello viewWillAppear")
        
        // 如果使用者預設有資料的話，就把資料匯入到addDict字典
        if myUserDefaults.value(forKey: "resultDict") != nil {
        
            addDict = (myUserDefaults.object(forKey: "resultDict") as? [String: [String:String]])!
            
        }
        
        getTotal()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return addDict.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ResultCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultTableViewCell
        
        cell.resultName?.text = Array(addDict.keys)[indexPath.row]
        cell.resultCount?.text =  Array(addDict.values)[indexPath.row]["count"]
        cell.resultSubtotal?.text = Array(addDict.values)[indexPath.row]["subtotal"]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let index = indexPath.row  //現在按的索引值
            var addDictKey = Array(addDict.keys)  // 把key全部取出來，放到陣列
            let key  = addDictKey[index]   // 抓到的索引值為陣列相對應的key


            if let idx = addDict.index(forKey: key) {
                addDict.remove(at: idx)

                let object = myUserDefaults.object(forKey: "resultDict") as! NSDictionary  // 把userDefaults的資料轉成NSDictionary
                let storedValue = NSMutableDictionary.init(dictionary:object) // 
                storedValue.removeObject(forKey: key) //
                
                print(storedValue)

                myUserDefaults.set(storedValue, forKey: "resultDict") //
                myUserDefaults.synchronize() //

                let newObject : NSMutableDictionary = myUserDefaults.object(forKey: "resultDict") as! NSMutableDictionary //
                print(newObject)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                getTotal()
                
               
            }
            
            }
        }
    
    func getTotal () {
        
        let dictValues = addDict.values
        let subtotalString = dictValues.map { $0["subtotal"] }
        let subtotalInt = subtotalString.compactMap { Int($0!) }
        let sum = subtotalInt.reduce(0, +)
        let sumString = String(sum)
        totalPriceLabel.text = sumString
        
    }
    

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
