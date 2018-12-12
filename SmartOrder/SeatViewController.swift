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
    var seatListener: ListenerRegistration?
    var waitingListener: ListenerRegistration?
    let SEAT_COLLECTION_NAME = "seat"
    let SEAT_DOCUMENT_NAME = "status"
    let WAITING_COLLECTION_NAME = "Reservation"
    let WAITING_DOCUMENT_NAME = "Waiting"
    
    var seatsStatus = [SeatStatus]()
    var idleTable = [SeatStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SeatViewController: viewWillAppear")
        addListener()
        downloadSeatStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if seatListener != nil {
            seatListener!.remove()
            seatListener = nil
        }
        
        if waitingListener != nil {
            waitingListener!.remove()
            waitingListener = nil
        }
    }
    
    deinit {
        print("SeatViewController deinit.")
    }
    
    // MARK: - Methods.
    func downloadSeatStatus() {
        // Get table status.
        firebaseCommunicator.loadData(collectionName: SEAT_COLLECTION_NAME, documentName: SEAT_DOCUMENT_NAME) { [weak self] (results, error) in
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
        
        // Get waiting status.
        let db = firebaseCommunicator.db
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        let date = dateFormatter.string(from: Date())
        db!.collection(WAITING_COLLECTION_NAME).document(WAITING_DOCUMENT_NAME).collection(date).getDocuments { [weak self] (querySnapshot, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                print("Load data error: \(error).")
            } else {
                print("Load data successful.")
                var results: [String: Any] = [:]
                for document in querySnapshot!.documents {
                    results.updateValue(document.data(), forKey: document.documentID)
                }
                print("waiting: \(results)")
                strongSelf.showWaitingStatus(input: results)
            }
        }
    }
    
    func showWaitingStatus(input: [String: Any]) {
        var insideCount = 0
        input.forEach { (key, value) in
            switch key {
            case "Number":
                let waitingNumber = (value as! [String: String])
                number.text = "目前號碼: \(waitingNumber["Number"]!)"
            default:
                let waitingStatus = (value as! [String: Any])
                waitingStatus.forEach({ (key, value) in
                    if let inside = value as? String, inside == "inside" {
                        insideCount += 1
                    }
                })
            }
        }
        underWaiting.text = "現場組數: \(insideCount)"
    }
    
    func addListener() {
        if let db = firebaseCommunicator.db, seatListener == nil {
            seatListener = db.collection(SEAT_COLLECTION_NAME).addSnapshotListener { [weak self] querySnapshot, error in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print("AddSeatListener error: \(error)")
                } else {
                    print("AddSeatListener successful.")
                    strongSelf.downloadSeatStatus()
                }
            }
        }
        
        if let db = firebaseCommunicator.db, waitingListener == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
            let date = dateFormatter.string(from: Date())
            waitingListener = db.collection(WAITING_COLLECTION_NAME).document(WAITING_DOCUMENT_NAME).collection(date).addSnapshotListener { [weak self] querySnapshot, error in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print("AddWaitingListener error: \(error)")
                } else {
                    print("AddWaitingListener successful.")
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
        
        cell.tableID.text = tableDecoder(tableID: seatsStatus[indexPath.row].tableID)
        cell.useTime.text = "用餐時間: \(useTime) 分鐘"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tableID = seatsStatus[indexPath.row].tableID
        let timestamp = FieldValue.serverTimestamp()
        let data = [tableID: ["isUsed": false, "timestamp": timestamp]]
        firebaseCommunicator.updateData(collectionName: SEAT_COLLECTION_NAME, documentName: SEAT_DOCUMENT_NAME, data: data) { [weak self] (isFinished, error) in
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
    
    func tableDecoder(tableID: String) -> String {
        switch tableID {
        case "table1":
            return "第一桌"
        case "table2":
            return "第二桌"
        case "table3":
            return "第三桌"
        case "table4":
            return "第四桌"
        case "table5":
            return "第五桌"
        case "table6":
            return "第六桌"
        case "table7":
            return "第七桌"
        case "table8":
            return "第八桌"
        default:
            return "Unkown"
        }
    }
}
