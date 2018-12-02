//
//  HotNewsCollectionViewCell.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/28.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit



class HotNewsCollectionViewCell: UICollectionViewCell {
    var firebaseCommunicator = FirebaseCommunicator.shared
    
    @IBOutlet weak var hotNewsListCollectionView: UICollectionView!
    
    var hotNewsInfos = [CouponInfo]()
    
    override func awakeFromNib() {
        hotNewsListCollectionView.delegate = self
        hotNewsListCollectionView.dataSource = self
    }
    
    func hotNewsListCollectionViewInit() {
        hotNewsListCollectionView.isPagingEnabled = true
        
    }
}

// MARK: - Handle collection view.
extension HotNewsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotNewsInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotNewsCell", for: indexPath) as! HotNewsCell
        firebaseCommunicator.downloadImage(url: "couponImages/", fileName: hotNewsInfos[indexPath.row].couponImageName) {(image, error) in
            if let error = error {
                print("download image error: \(error)")
            } else {
                cell.hotNewsImage.image = (image as! UIImage)
            }
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenWidth = UIScreen.main.bounds.width
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset = CGPoint(x: CGFloat(hotNewsInfos.count + 1) * screenWidth, y: 0)
        }
    }
}
