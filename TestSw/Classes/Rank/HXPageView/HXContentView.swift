
//
//  HXContentView.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/12.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

private let identifierID = "identifierID"

protocol HXContentViewDelegate : class {
    func contenView(_ contentView : HXContentView, targetIndex : Int)
    func contenView(_ contentView : HXContentView, targetIndex : Int, progress : CGFloat)
}

class HXContentView: UIView {

    weak var delegatet : HXContentViewDelegate?
    
    fileprivate var childrenVC : [UIViewController]
    fileprivate var parentVC : UIViewController
    fileprivate var startOffsetX : CGFloat = 0
    
    fileprivate lazy var collectionView : UICollectionView =  {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifierID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    init(frame: CGRect, childrenVC : [UIViewController], parendVC : UIViewController) {
        self.childrenVC = childrenVC
        self.parentVC = parendVC
        
        super.init(frame : frame)
        setUPUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HXContentView {
    fileprivate func setUPUI() {
        for child in childrenVC {
            parentVC.addChildViewController(child)
        }
        addSubview(collectionView)
    }
}


extension HXContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childrenVC.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierID, for: indexPath)
        
        for subViews in cell.contentView.subviews {
            subViews.removeFromSuperview()
        }
        let chileVC = childrenVC[indexPath.row]
        chileVC.view.frame = cell.contentView.bounds
        cell.addSubview(chileVC.view)
        
        return cell
    }
}

extension HXContentView : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    
    private func contentEndScroll() {
        // 1.获取滚动到的位置
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // 2.通知titleView进行调整
        delegatet?.contenView(self, targetIndex: currentIndex)

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断和开始时的偏移量是否一致x
        guard startOffsetX != scrollView.contentOffset.x else {
            return
        }
        
        // 1.定义targetIndex/progress
        var targetIndex = 0
        var progress : CGFloat = 0.0
        
        // 2.给targetIndex/progress赋值
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX < scrollView.contentOffset.x { // 左滑动
            targetIndex = currentIndex + 1
            if targetIndex > childrenVC.count - 1 {
                targetIndex = childrenVC.count - 1
            }
            
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
        } else { // 右滑动
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        // 3.通知代理
        delegatet?.contenView(self, targetIndex: targetIndex, progress: progress)

    }
    
}


extension HXContentView : HXTitleViewDelegate {
    func titleView(_ titleview: HXTitleView, target: Int) {
        let indexPath = IndexPath(item: target, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}


