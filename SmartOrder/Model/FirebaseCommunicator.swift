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
    
    private init() {
        db = Firestore.firestore()
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
        db.collection(collectionName).document(documentName).setData(data) { error in
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
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Load data successful.")
                completion(dataDescription, nil)
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
    
}
