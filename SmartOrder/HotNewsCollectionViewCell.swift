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
    
    var hotNewsInfo = [CouponInfo]()
    
    override func awakeFromNib() {
        hotNewsListCollectionView.delegate = self
        hotNewsListCollectionView.dataSource = self
        
    }
    
    func hotNewsListCollectionViewInit() {
        hotNewsListCollectionView.isPagingEnabled = true
        
    }
}

// Handle collection view.
extension HotNewsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotNewsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotNewsCell", for: indexPath) as! HotNewsCell
        firebaseCommunicator.downloadImage(url: "couponImages/", fileName: hotNewsInfo[indexPath.row].couponImageName) {(image, error) in
            if let error = error {
                print("download image error: \(error)")
            } else {
                cell.hotNewsImage.image = (image as! UIImage)
            }
        }
        return cell
    }
}
