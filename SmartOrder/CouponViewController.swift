//
//  CouponViewController.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/8.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class CouponViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //var authHandle: AuthStateDidChangeListenerHandle?
    //var db: Firestore!
    
    var firebaseCommunicator = FirebaseCommunicator.shared
    
    @IBOutlet weak var cvCouponList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvCouponList.delegate = self
        cvCouponList.dataSource = self
        
//        let data = ["data1": 123, "data2": "hello"] as [String : Any]
//        firebaseCommunicator.addData(collectionName: "test", documentName: "add", data: data) { (result, error) in
//            if let error = error {
//                print("error: \(error)")
//            }
//        }

//        //let data2 = ["data1": 321] as [String : Any]
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.firebaseCommunicator.updateData(collectionName: "coupon", documentName: "002", data: data2, completion: { (results, error) in
//
//            })
//        }
        
//        firebaseCommunicator.deleteData(collectionName: "test", documentName: "add") { (results, error) in
//            if let error = error {
//                print("error: \(error)")
//            }
//        }
//
        
//        firebaseCommunicator.loadData(collectionName: "test") { (results, error) in
//            if let error = error {
//                print("error: \(error)")
//            } else {
//                let results = results as! [String: Any]
//                print("result: \(results)")
//            }
//        }
        

        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.firebaseCommunicator.loadData(collectionName: "coupon") { (results, error) in
//                if let error = error {
//                    print("error: \(error)")
//                } else {
//                    print("load results: \(results!)")
//                }
//            }
//        }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.firebaseCommunicator.loadData(collectionName: "coupon", documentName: "002") { (results, error) in
//                if let error = error {
//                    print("error: \(error)")
//                } else {
//                    guard let results = results else {
//                        return
//                    }
//                    let result = results as! [String: Any]
//                    guard let timestamp = result["timestamp"] else {
//                        return
//                    }
//                    print("load 002 results: \(timestamp)")
//
//                }
//            }
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.firebaseCommunicator.loadData(collectionName: "test", greaterThanOrEqualTo: "2018-11-23 09:00:00", lessThanOrEqualTo: "2018-11-23 09:10:00", completion: { (results, error) in
//                if let error = error {
//                    print("error: \(error)")
//                } else {
//                    print("results: \(results!)")
//                }
//            })
//        }
        
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateformatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
//        let date = dateformatter.date(from: "2018-11-23 09:15:19")
//        // 1542935719
//        print("dateeeeeee: \(date!)")
//        let timestamp = Timestamp(date: date!)
//        print("timestamp: \(timestamp)")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.firebaseCommunicator.loadData(collectionName: "coupon", field: "timestamp", condition: timestamp, completion: { (results, error) in
//                if let error = error {
//                    print("error: \(error)")
//                } else {
//                    print("load data1 results: \(results!)")
//                }
//            })
//        }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.firebaseCommunicator.deleteData(collectionName: "coupon", documentName: "001", completion: { (results, error) in
//                if let error = error {
//                    print("error: \(error)")
//                } else {
//                    print("delete data successful.")
//                }
//            })
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.firebaseCommunicator.deleteData(collectionName: "coupon", documentName: "002", data: "data1", completion: { (results, error) in
//                if let error = error {
//                    print("error: \(error)")
//                } else {
//                    print("delete data successful.")
//                }
//            })
//        }
        
//        firebaseCommunicator.addData(collectionName: "coupon", documentName: "001", data: data)
//        data = ["data1": 321] as [String : Any]
//        firebaseCommunicator.updateData(collectionName: "coupon", documentName: "001", data: data)
//        firebaseCommunicator.loadData(collectionName: "coupon", documentName: "001")
//        firebaseCommunicator.loadData(collectionName: "coupon", documentName: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.firebaseCommunicator.loadData(collectionName: "coupon", documentName: "001")
//        }
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CouponCollectionViewCell
        return cell
    }
}
