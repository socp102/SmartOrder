//
//  StarTableViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/19.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class StarTableViewController: UITableViewController {
    var firebase = FirebaseCommunicator.shared
    var finalmessage = Message()
    var object = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.object.removeAll()
        self.tableView.tableFooterView = UIView()
        load()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return object.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "starlist", for: indexPath)
        cell.selectionStyle = .none
        let item = object[indexPath.row]
        if item.manager != "" {
            cell.detailTextLabel?.textColor = UIColor.blue
            cell.detailTextLabel?.text = "已回覆"
            
        }else{
            cell.detailTextLabel?.textColor = UIColor.red
            cell.detailTextLabel?.text = "未回覆"
        }
        
        
        cell.textLabel?.text = item.time
        return cell
    }

    func load() {
       
        firebase.loadData(collectionName: "message") { (result, error) in
            if let error = error {
                print("error :\(error)")
            }
            let finial = result as! [String:[String:Any]]
            //let total = finial as! [String:Any]
            finial.forEach({ (key, total) in
                self.finalmessage.key = key
                self.finalmessage.manager = total["manager"] as? String ?? ""
                self.finalmessage.star = total["star"] as? Int ?? 0
                self.finalmessage.visitor = total["visitor"] as? String ?? ""
                self.finalmessage.time = total["time"] as? String ?? ""
                self.finalmessage.email = total["name"] as? String ?? ""
                self.finalmessage.uid = total["uid"] as? String ?? ""
                self.object.append(self.finalmessage)
            })
            
            print("object: \(self.object)")
            self.tableView.reloadData()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "starsegue" {
            let controller = segue.destination as! StarDetialViewController
            if let row = tableView.indexPathForSelectedRow?.row {
                let courseSelect = object[row]
                controller.detialobject = courseSelect
            }
            
        }
    }

}
