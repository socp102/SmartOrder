//
//  HotNewsCollectionViewCell.swift
//  SmartOrder
//
//  Created by BorisChen on 2018/11/28.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit



class HotNewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hotNewsListCollectionView: UICollectionView!
    
    var hotNewsInfos = [UIImage]()
    var pageControl = UIPageControl()
    var imageIndex = 1
    var timer: Timer?
    
    override func awakeFromNib() {
        hotNewsListCollectionView.delegate = self
        hotNewsListCollectionView.dataSource = self
        enableTimer()
    }
    
    deinit {
        print("HotNewsCollectionViewCell deinit.")
    }
    
    @objc func changeHotNewsInfos() {
        pageControl.currentPage = imageIndex
        imageIndex += 1
        var isAnimatedEnable = true
        if imageIndex >= hotNewsInfos.count + 1 {
            imageIndex = 0
            isAnimatedEnable = false
        }
        let indexPath = IndexPath(row: imageIndex, section: 0)
        hotNewsListCollectionView.selectItem(at: indexPath, animated: isAnimatedEnable, scrollPosition: .centeredHorizontally)
        if !isAnimatedEnable {
            changeHotNewsInfos()
        }
    }
    
    // MARK: - Methods.
    func enableTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeHotNewsInfos), userInfo: nil, repeats: true)
        }
    }
}

// MARK: - Handle collection view.
extension HotNewsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotNewsInfos.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotNewsCell", for: indexPath) as! HotNewsCell
        switch indexPath.row {
        case 0:
            cell.hotNewsBtn.setBackgroundImage(hotNewsInfos.last, for: .normal)
        case self.hotNewsInfos.count + 1:
            cell.hotNewsBtn.setBackgroundImage(hotNewsInfos.first, for: .normal)
        default:
            cell.hotNewsBtn.setBackgroundImage(hotNewsInfos[indexPath.row - 1], for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return hotNewsListCollectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenWidth = UIScreen.main.bounds.width
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset = CGPoint(x: CGFloat(hotNewsInfos.count) * screenWidth, y: 0)
            pageControl.currentPage = hotNewsInfos.count
            imageIndex = hotNewsInfos.count
        } else if (scrollView.contentOffset.x == CGFloat(hotNewsInfos.count + 1) * screenWidth) {
            scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
            pageControl.currentPage = 0
            imageIndex = 1
        } else {
            pageControl.currentPage = Int(scrollView.contentOffset.x / screenWidth) - 1
            imageIndex = Int(scrollView.contentOffset.x / screenWidth)
        }
    }
}
