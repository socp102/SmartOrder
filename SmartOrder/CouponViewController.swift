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
    
    // Download data.
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
                resultsDictionary.forEach({ (key, value) in
                    var result = value as! [String: Any]
                    result.removeValue(forKey: "timestamp")
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
    
    @IBAction func moreBtnPressed(_ sender: UIButton) {
        showCouponDetail(senderTag: sender.tag)
    }
    
//    @IBAction func moreBtnPressed(_ sender: UIButton) {
//        showCouponDetail(senderTag: sender.tag)
//    }
    
    var detailView: UIView?
    
    func showCouponDetail(senderTag: Int) {
        if detailView != nil {
            return
        }
        let couponInfo = couponInfos[senderTag]
        let detailHeigh = UIScreen.main.bounds.height
        let detailWidth = UIScreen.main.bounds.width
        var totalHeight: CGFloat = 0.0
        
        // 增加底層View
        detailView = UIView(frame: CGRect(x: 0, y: 0, width: detailWidth, height: detailHeigh))
        detailView!.backgroundColor = UIColor.white
        
        // 增加couponImage
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let localImageURL = cacheURL.appendingPathComponent("couponImages/\(couponInfo.couponImageName)")
        print("localImageURL: \(localImageURL)")
        // 從本機Cache取得圖片.
        guard let data = try? Data(contentsOf: localImageURL) else {
            print("getData from local successful.")
            return
        }
        let detailImage = UIImageView(frame: CGRect(x: 0, y: 0, width: detailWidth, height: 250))
        detailImage.image = UIImage(data: data)
        detailView!.addSubview(detailImage)
        
        // 增加couponTitle
        totalHeight += detailImage.bounds.height + 20.0
        let detailTitle = UILabel(frame: CGRect(x: 10, y: Int(totalHeight), width: Int(detailWidth - 10), height: 20))
        detailTitle.text = couponInfo.couponTitle
        detailView!.addSubview(detailTitle)
        
        // 增加couponValidDate
        totalHeight += detailTitle.bounds.height + 20.0
        let detailValidDate = UILabel(frame: CGRect(x: 10, y: Int(totalHeight), width: Int(detailWidth - 10), height: 20))
        detailValidDate.text = "使用期限: \(couponInfo.couponValidDate)"
        detailView!.addSubview(detailValidDate)
        
        // 增加couponContent
        totalHeight += detailValidDate.bounds.height + 30.0
        let detailContent = UILabel(frame: CGRect(x: 10, y: Int(totalHeight), width: Int(detailWidth - 10), height: 20))
        detailContent.text = couponInfo.couponDetilContent
        detailView!.addSubview(detailContent)
        
        // 增加優惠券資訊
        totalHeight += detailContent.bounds.height + 30.0
        let detailQty = UILabel(frame: CGRect(x: Int(detailWidth / 3) - 75, y: Int(totalHeight), width: 150, height: 20))
        detailQty.text = "優惠券剩餘: \(couponInfo.couponQty) 張"
        detailView?.addSubview(detailQty)
        let receiveBtn = UIButton(frame: CGRect(x: Int(detailWidth / 3) + 90, y: Int(totalHeight), width: 100, height: 20))
        receiveBtn.setTitle("領取優惠券", for: .normal)
        receiveBtn.setTitleColor(.blue, for: .normal)
        receiveBtn.addTarget(self, action: #selector(tapReceiveBtn), for: .touchUpInside)
        detailView!.addSubview(receiveBtn)
        
        // 增加cancelBtn
        totalHeight += detailContent.bounds.height + 20.0
        let cancelBtn = UIButton(frame: CGRect(x: detailWidth - 42, y: 20, width: 32, height: 32))
        cancelBtn.setImage(UIImage(named: "cancel.png"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(tapCancelBtn), for: .touchUpInside)
        detailView!.addSubview(cancelBtn)
        
        // 增加動畫
        detailView!.transform = CGAffineTransform(translationX: 600, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: [.curveEaseIn], animations: {
            self.detailView!.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (result) in
            
        }
        
        self.view.addSubview(detailView!)
        
    }
    
    @objc
    func tapCancelBtn() {
        detailView?.removeFromSuperview()
        detailView = nil
    }
    
    @objc
    func tapReceiveBtn() {
        
    }
}

// Handle collection view.
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
//            cell.hotNewsListCollectionView.delegate = self
//            cell.hotNewsListCollectionView.dataSource = self
//            cell.hotNewsListCollectionView.tag = 999
            cell.hotNewsInfo = couponInfos
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

