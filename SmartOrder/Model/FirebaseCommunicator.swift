//
//  FirebaseCommunicator.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/15.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation
import Firebase

class FirebaseCommunicator {
    static let shared = FirebaseCommunicator()
    let db: Firestore!
    
    let storage: Storage!
    
    private init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        storage = Storage.storage()
    }
    
    
    typealias DoneHandler = (_ results: Any?, _ errorCode: Error?) -> Void
    
    // 新增data.
    func addData(collectionName: String,
                 documentName: String,
                 data: [String: Any],
                 overwrite: Bool = true,
                 completion: @escaping DoneHandler) {
        var finalData = data
        finalData.updateValue(FieldValue.serverTimestamp(), forKey: "timestamp")
        db.collection(collectionName).document(documentName).setData(finalData) { error in
            if let  error = error {
                print("Add data error: \(error).")
                completion(nil, error)
            } else {
                print("Add data successful.")
            }
        }
    }
    
    // 刪除documentName的Data.
    func deleteData(collectionName: String,
                    documentName: String,
                    completion: @escaping DoneHandler) {
        db.collection(collectionName).document(documentName).delete() { error in
            if let  error = error {
                print("Delete data error: \(error).")
                completion(nil, error)
            } else {
                print("Delete data successful.")
            }
        }
    }
    
    // 刪除documentName其中一筆Data.
    func deleteData(collectionName: String,
                    documentName: String,
                    data: String,
                    completion: @escaping DoneHandler) {
        db.collection(collectionName).document(documentName).updateData([data: FieldValue.delete()]) { error in
            if let  error = error {
                print("Delete data error: \(error).")
                completion(nil, error)
            } else {
                print("Delete data successful.")
            }
        }
    }
    
    // 修改data.
    func updateData(collectionName: String,
                    documentName: String,
                    data: [String: Any],
                    completion: @escaping DoneHandler) {
        let target = db.collection(collectionName).document(documentName)
        db.runTransaction({ (transaction, error) -> Any? in
            transaction.updateData(data, forDocument: target)
            return nil
        }) { (results, error) in
            if let error = error {
                print("Update data error: \(error).")
                completion(nil, error)
            } else {
                print("Update data successful.")
            }
        }
    }
    
    // 查詢collectionName內所有data.
    func loadData(collectionName: String,
                  completion: @escaping DoneHandler) {
        db.collection(collectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Load data error: \(error).")
                completion(nil, error)
            } else {
                print("Load data successful.")
                var results: [String: Any] = [:]
                for document in querySnapshot!.documents {
                    results.updateValue(document.data(), forKey: document.documentID)
                }
                completion(results, error)
            }
        }
    }
    
    // 查詢documentName內所有data.
    func loadData(collectionName: String,
                  documentName: String,
                  completion: @escaping DoneHandler) {
        db.collection(collectionName).document(documentName).getDocument { (document, error) in
            if let document = document, document.exists {
                print("Load data: \(document.data()!)")
                completion(document.data(), nil)
            } else {
                print("Load data error: \(error!).")
                completion(nil, error)
            }
        }
    }
    
    // 查詢collectionName內所有符合condition的field之data.
    func loadData(collectionName: String,
                  field: String,
                  condition: Any,
                  completion: @escaping DoneHandler) {
        db.collection(collectionName).whereField(field, isEqualTo: condition).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Load data error: \(error).")
                completion(nil, error)
            } else {
                print("Load data successful.")
                var results: [String: Any] = [:]
                for document in querySnapshot!.documents {
                    results.updateValue(document.data(), forKey: document.documentID)
                }
                completion(results, nil)
            }
        }
    }
    
    // 查詢collectionName內所有符合時間範圍內之data.
    func loadData(collectionName: String,
                  greaterThanOrEqualTo start: String? = nil,
                  lessThanOrEqualTo end: String? = nil,
                  completion: @escaping DoneHandler) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        
        if let startTime = start, let endTime = end {
            let startDate = dateformatter.date(from: startTime)
            let startTimestamp = Timestamp(date: startDate!)
            let endDate = dateformatter.date(from: endTime)
            let endTimestamp = Timestamp(date: endDate!)
            
            db.collection(collectionName).whereField("timestamp", isGreaterThanOrEqualTo: startTimestamp).whereField("timestamp", isLessThanOrEqualTo: endTimestamp).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Load data error: \(error).")
                    completion(nil, error)
                } else {
                    print("Load data successful.")
                    var results: [String: Any] = [:]
                    for document in querySnapshot!.documents {
                        results.updateValue(document.data(), forKey: document.documentID)
                    }
                    completion(results, nil)
                }
            }
        }
        
        if let startTime = start, end == nil {
            let startDate = dateformatter.date(from: startTime)
            let startTimestamp = Timestamp(date: startDate!)
            
            db.collection(collectionName).whereField("timestamp", isGreaterThanOrEqualTo: startTimestamp).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Load data error: \(error).")
                    completion(nil, error)
                } else {
                    print("Load data successful.")
                    var results: [String: Any] = [:]
                    for document in querySnapshot!.documents {
                        results.updateValue(document.data(), forKey: document.documentID)
                    }
                    completion(results, nil)
                }
            }
        }
        
        if start == nil, let endTime = end {
            let endDate = dateformatter.date(from: endTime)
            let endTimestamp = Timestamp(date: endDate!)
            
            db.collection(collectionName).whereField("timestamp", isLessThanOrEqualTo: endTimestamp).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Load data error: \(error).")
                    completion(nil, error)
                } else {
                    print("Load data successful.")
                    var results: [String: Any] = [:]
                    for document in querySnapshot!.documents {
                        results.updateValue(document.data(), forKey: document.documentID)
                    }
                    completion(results, nil)
                }
            }
        }
    }
}
