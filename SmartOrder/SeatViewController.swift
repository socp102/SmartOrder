//
//  SeatViewController.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/12/6.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class SeatViewController: UIViewController {
    @IBOutlet weak var seatCollectionView: UICollectionView!
    @IBOutlet weak var underWaiting: UILabel!
    @IBOutlet weak var number: UILabel!
    
    let firebaseCommunicator = FirebaseCommunicator.shared
    var listener: ListenerRegistration?
    let FIREBASE_COLLECTION_NAME = "seat"
    let FIREBASE_DOCUMENT_NAME = "status"
    
    var seatsStatus = [SeatStatus]()
    var idleTable = [SeatStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("adfg: viewWillAppear")
        addListener()
        downloadSeatStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if listener != nil {
            listener!.remove()
            listener = nil
        }
    }
    
    deinit {
        print("SeatViewController deinit.")
    }
    
    // MARK: - Methods.
    func downloadSeatStatus() {
        firebaseCommunicator.loadData(collectionName: FIREBASE_COLLECTION_NAME, documentName: FIREBASE_DOCUMENT_NAME) { [weak self] (results, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print("Download error: \(error)")
            } else if let results = results as? [String: Any] {
                print("results: \(results)")
                strongSelf.idleTable.removeAll()
                strongSelf.seatsStatus.removeAll()
                results.forEach({ (tableID, info) in
                    guard let info = info as? [String: Any] else {
                        return
                    }
                    let isUsed = info["isUsed"] as! Bool
                    let timestamp = info["timestamp"] as! Timestamp
                    if isUsed {
                        strongSelf.seatsStatus.append(SeatStatus(tableID: tableID, isUsed: isUsed, timestamp: timestamp))
                    } else {
                        strongSelf.idleTable.append(SeatStatus(tableID: tableID, isUsed: isUsed, timestamp: timestamp))
                    }
                })
                strongSelf.seatsStatus.sort(by: { (first, second) -> Bool in
                    return first.timestamp.seconds < second.timestamp.seconds
                })
                strongSelf.idleTable.sort(by: { (first, second) -> Bool in
                    return first.tableID < second.tableID
                })
                strongSelf.seatCollectionView.delegate = strongSelf
                strongSelf.seatCollectionView.dataSource = strongSelf
                strongSelf.seatCollectionView.reloadData()
            }
        }
    }
    
    func addListener() {
        if let db = firebaseCommunicator.db, listener == nil {
            listener = db.collection(FIREBASE_COLLECTION_NAME).addSnapshotListener { [weak self] querySnapshot, error in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print("AddSnapshotListener error: \(error)")
                } else {
                    print("AddSnapshotListener successful.")
                    strongSelf.downloadSeatStatus()
                }
            }
        }
    }
    
    // MARK: - Button pressed.
    @IBAction func passBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func refreshBtnPressed(_ sender: UIBarButtonItem) {
        downloadSeatStatus()
    }
}

extension SeatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionTitle = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "seatSectionCell", for: indexPath) as? SeatSectionCollectionReusableView else {
            return UICollectionReusableView()
        }
        var tableID = ""
        idleTable.forEach { (table) in
            let table = table.tableID
            tableID.append(String(table[table.index(table.startIndex, offsetBy: 5)]) + ", ")
        }
        sectionTitle.seatSummary.text = "空桌: \(idleTable.count) 桌 -> \(tableID) \n使用中: \(seatsStatus.count) 桌"
        return sectionTitle
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seatsStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCell", for: indexPath) as? SeatCollectionViewCell else {
            return UICollectionViewCell()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        let timestampToDouble = Double(seatsStatus[indexPath.row].timestamp.seconds)
        let currentTime = Double(Timestamp(date: Date()).seconds)
        let useTime = Int((currentTime - timestampToDouble) / 60)
        switch useTime {
        case 0..<30:
            cell.cardView.backgroundColor = UIColor(red: 134/255, green: 193/255, blue: 102/255, alpha: 1.0)
        case 30..<60:
            cell.cardView.backgroundColor = UIColor(red: 246/255, green: 197/255, blue: 86/255, alpha: 1.0)
        default:
            cell.cardView.backgroundColor = UIColor(red: 245/255, green: 150/255, blue: 170/255, alpha: 1.0)
        }
        
        cell.tableID.text = seatsStatus[indexPath.row].tableID
        cell.useTime.text = "用餐時間: \(useTime) 分鐘"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tableID = seatsStatus[indexPath.row].tableID
        let timestamp = FieldValue.serverTimestamp()
        let data = [tableID: ["isUsed": false, "timestamp": timestamp]]
        firebaseCommunicator.updateData(collectionName: FIREBASE_COLLECTION_NAME, documentName: FIREBASE_DOCUMENT_NAME, data: data) { [weak self] (isFinished, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                print("Updated error: \(error)")
            } else {
                strongSelf.downloadSeatStatus()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
