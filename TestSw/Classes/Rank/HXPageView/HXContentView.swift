
//
//  HXContentView.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/12.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

private let identifierID = "identifierID"

@objc protocol HXContentViewDelegate : class {
    
    func contentView(_ contentView : HXContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
   
    @objc optional func contentViewEndScroll(_ contentView : HXContentView)

    
//    func contenView(_ contentView : HXContentView, targetIndex : Int)
//    func contenView(_ contentView : HXContentView, targetIndex : Int, progress : CGFloat)
}

class HXContentView: UIView {

    weak var delegatet : HXContentViewDelegate?
    
    fileprivate var childrenVC : [UIViewController]
    fileprivate var parentVC : UIViewController
    
    fileprivate var isForbidScrollDelegate : Bool = false

    fileprivate var startOffsetX : CGFloat = 0
    
    fileprivate var isForbidScroll : Bool = false

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
        let chileVC = childrenVC[indexPath.item]
        chileVC.view.frame = cell.contentView.bounds
        cell.addSubview(chileVC.view)
        
        return cell
    }
}

extension HXContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childrenVC.count {
                targetIndex = childrenVC.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childrenVC.count {
                sourceIndex = childrenVC.count - 1
            }
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegatet?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegatet?.contentViewEndScroll?(self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegatet?.contentViewEndScroll?(self)
        }
    }
    
}

//extension HXContentView : HXTitleViewDelegate {
//    func titleView(_ titleview: HXTitleView, target: Int) {
//        isForbidScroll = true
//
//        let indexPath = IndexPath(item: target, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
//    }
//}

// MARK:- 对外暴露的方法
extension HXContentView {
    func setCurrentIndex(_ currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
