//
//  ResultTableViewController.swift
//  SmartOrder
//
//  Created by Lu Kevin on 2018/11/20.
//  Copyright © 2018年 Eason. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    let myUserDefaults = UserDefaults.standard
    var addDict =  [String: [String]]()
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBAction func resultCloseBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func sendOrderToFirebase(_ sender: Any) {
        
        myUserDefaults.removeObject(forKey: "resultDict")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // 如果使用者預設有資料的話，就把資料匯入到addDict字典
        if myUserDefaults.value(forKey: "resultDict") != nil {
        
        addDict = (myUserDefaults.object(forKey: "resultDict") as? [String: [String]])!
            
        }
        
        
        let dictValues = addDict.values
        let subtotalString = dictValues.map { $0[1] }
        let subtotalInt = subtotalString.compactMap { Int($0) }
        let sum = subtotalInt.reduce(0, +)
        totalPriceLabel.text = String(sum)
        
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
        cell.resultCount?.text =  Array(addDict.values)[indexPath.row][0]
        cell.resultSubtotal?.text = Array(addDict.values)[indexPath.row][1]
        
        return cell
    }
    

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
