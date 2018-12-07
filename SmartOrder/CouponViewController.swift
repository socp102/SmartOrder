//
//  CouponViewController.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/8.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit

class CouponViewController: UIViewController {
    @IBOutlet weak var couponListCollectionView: UICollectionView!
    
    let firebaseCommunicator = FirebaseCommunicator.shared
    var couponInfos = [CouponInfo]()
    var hotNewsInfos = [UIImage]()
    let screenWidth = UIScreen.main.bounds.width
    var animateDelay: Double = 0.0
    var animateEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCouponInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadCouponInfo()
        guard let cell = view.viewWithTag(1000) as? HotNewsCollectionViewCell else {
            return
        }
        if cell.timer == nil {
            cell.enableTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateEnable = false
        guard let cell = view.viewWithTag(1000) as? HotNewsCollectionViewCell else {
            return
        }
        if cell.timer != nil {
            cell.timer!.invalidate()
            cell.timer = nil
        }
    }
    
    deinit {
        print("Coupon page deinit.")
    }
    
    // MARK: - Methods.
    func downloadCouponInfo() {
        animateDelay = 0.0
        firebaseCommunicator.loadData(collectionName: "couponInfo", completion: { [weak self] (results, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                print("loadData error: \(error)")
            } else {
                print("results: \(results!)")
                let resultsDictionary = results as! [String: Any]
                strongSelf.couponInfos.removeAll()
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
                
                resultsDictionary.forEach({ (key, value) in
                    var result = value as! [String: Any]
                    result.removeValue(forKey: "timestamp")
                    result.updateValue(key, forKey: "couponID")
                    let jsonData = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    if let couponInfo = try? decoder.decode(CouponInfo.self, from: jsonData) {
                        let validDate = dateFormatter.date(from: couponInfo.couponValidDate)
                        if currentDate < validDate! {
                            strongSelf.couponInfos.append(couponInfo)
                        }
                    }
                })
                strongSelf.couponInfos = strongSelf.couponInfos.sorted(by: { (first, second) -> Bool in
                    return first.couponImageName < second.couponImageName
                })
                print("couponInfos: \(strongSelf.couponInfos)")
                strongSelf.downloadHotNewsInfo(competion: { (isCompetion) in
                    if isCompetion != nil {
                        strongSelf.couponListCollectionView.delegate = self
                        strongSelf.couponListCollectionView.dataSource = self
                        strongSelf.couponListCollectionView.reloadData()
                    }
                })
            }
        })
    }
    
    typealias downloadImageHandler = (_ competion: Bool?) -> Void
    func downloadHotNewsInfo(competion: @escaping downloadImageHandler) {
        hotNewsInfos.removeAll()
        var count = 0
        for index in couponInfos {
            print("imgage: \(index.couponImageName)")
            firebaseCommunicator.downloadImage(url: "couponImages/", fileName: index.couponImageName) {[weak self] (image, error) in
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    print("download image error: \(error)")
                } else {
                    count += 1
                    let image = image as! UIImage
                    strongSelf.hotNewsInfos.append(image)
                    if strongSelf.couponInfos.count == count {
                        competion(true)
                    }
                }
            }
        }
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
        guard let cell = view.viewWithTag(1000) as? HotNewsCollectionViewCell else {
            return
        }
        if cell.timer == nil {
            cell.timer = Timer.scheduledTimer(timeInterval: 2, target: cell, selector: #selector(cell.changeHotNewsInfos), userInfo: nil, repeats: true)
        }
    }
}


// MARK: - Handle collection view.
extension CouponViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotNewsInfoCell", for: indexPath) as? HotNewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.tag = 1000
            cell.hotNewsInfos = hotNewsInfos // DataSource
            let pageControl = generatePageControl()
            cell.addSubview(pageControl)
            cell.hotNewsListCollectionView.reloadData()
            cell.hotNewsListCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at:.left, animated: false)
            cell.pageControl = pageControl
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "couponInfoCell", for: indexPath) as? CouponCollectionViewCell else {
                return UICollectionViewCell()
            }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard animateEnable, indexPath.section > 0 else {
            return
        }
        
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1 * animateDelay,
            animations: {
                cell.alpha = 1
        })
        animateDelay += 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        if indexPath.section == 0 {
            return CGSize(width: screenWidth, height: 100)
        } else {
        return CGSize(width: screenWidth, height: 160)
        }
    }
    
    // Generate PgaeControl.
    func generatePageControl() -> UIPageControl {
        let pageControl = UIPageControl(frame: CGRect(x: screenWidth - 40, y: 90, width: 0, height: 0))
        pageControl.numberOfPages = hotNewsInfos.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.gray
        return pageControl
    }
}

