//
//  CouponViewController.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/8.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class CouponViewController: UIViewController {
    @IBOutlet weak var couponListCollectionView: UICollectionView!
    
    var firebaseCommunicator = FirebaseCommunicator.shared
    var couponInfos = [CouponInfo]()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        couponListCollectionView.delegate = self
        couponListCollectionView.dataSource = self
        
        downloadCouponInfo()
    }
    
    deinit {
        print("Coupon page deinit.")
    }
    
    // MARK: - Methods.
    func downloadCouponInfo() {
        firebaseCommunicator.loadData(collectionName: "couponInfo", completion: {[weak self] (results, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                print("loadData error: \(error)")
            } else {
                print("results: \(results!)")
                let resultsDictionary = results as! [String: Any]
                strongSelf.couponInfos.removeAll()
                resultsDictionary.forEach({ (key, value) in
                    var result = value as! [String: Any]
                    result.removeValue(forKey: "timestamp")
                    result.updateValue(key, forKey: "couponID")
                    let jsonData = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    if let couponInfo = try? decoder.decode(CouponInfo.self, from: jsonData) {
                        strongSelf.couponInfos.append(couponInfo)
                    }
                })
                strongSelf.couponInfos = strongSelf.couponInfos.sorted(by: { (first, second) -> Bool in
                    return first.couponImageName < second.couponImageName
                })
            }
            print("couponInfos: \(strongSelf.couponInfos)")
            strongSelf.couponListCollectionView.reloadData()
        })
    }
    
    // MARK: - Page changed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let moreBtn = sender as! UIButton
        let moreBtnTag = moreBtn.tag
        let couponInfo = couponInfos[moreBtnTag]
        guard let detailPage = segue.destination as? CouponDetailViewController else {
            return
        }
        detailPage.couponInfo = couponInfo
    }
    
    @IBAction func unwindToCouponPage(_ unwindSegue: UIStoryboardSegue) {
        downloadCouponInfo()
        
    }
}


// MARK: - Handle collection view.
extension CouponViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionTitleCell", for: indexPath) as? SectionTitleCollectionReusableView else {
            return UICollectionReusableView()
        }
        switch indexPath.section {
        case 0:
            sectionHeader.sectionTitle.text = "熱門主打"
        default:
            sectionHeader.sectionTitle.text = "優惠資訊"
        }
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return couponInfos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotNewsInfoCell", for: indexPath) as! HotNewsCollectionViewCell
            cell.hotNewsInfos = couponInfos // DataSource
            cell.hotNewsListCollectionView.reloadData()
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "couponInfoCell", for: indexPath) as! CouponCollectionViewCell
            firebaseCommunicator.downloadImage(url: "couponImages/", fileName: couponInfos[indexPath.row].couponImageName) {(image, error) in
                if let error = error {
                    print("download image error: \(error)")
                } else {
                    cell.couponImage.image = (image as! UIImage)
                }
            }
            print("couponInfos[\(indexPath.row)].couponTitle = \(couponInfos[indexPath.row].couponTitle)")
            cell.couponTitle.text = couponInfos[indexPath.row].couponTitle
            cell.moreBtn.tag = indexPath.row
            return cell
        }
    }
}

