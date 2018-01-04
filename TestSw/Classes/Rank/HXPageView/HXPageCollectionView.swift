//
//  HXPageCollectionView.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/26.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

protocol HXPageCollectionViewDataSource : class {
    func numberOfSections(in pageCollectionView : HXPageCollectionView) -> Int
    func pageCollectionView(_ collectionView : HXPageCollectionView, numberOfItemsInsection section : Int) -> Int
    func pageCollectionView(_ pageCollectionView: HXPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol HXPageCollectionViewDelegate : class {
    func pageCollectionview(_ pageCollectionView: HXPageCollectionView, didSelectItem indexPath: IndexPath)
}

class HXPageCollectionView: UIView {

    weak var dataSource : HXPageCollectionViewDataSource?
    weak var delegate : HXPageCollectionViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var isTitleInTop : Bool
    fileprivate var style : HXTitleStyle
    fileprivate var layout : HXWaterfallLayout
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var titleView : HXTitleView!
    fileprivate var sourceIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    
    
    init(frame : CGRect, titles : [String], style : HXTitleStyle, isTitleInTop : Bool, layout : HXWaterfallLayout) {
        self.titles = titles
        self.style = style
        self.layout = layout
        self.isTitleInTop = isTitleInTop
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension HXPageCollectionView {
    fileprivate func setUpUI() {
        // 创建titleView
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.size.width, height: style.titleHeight)
        titleView = HXTitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.randomColor()
        
        // 创建pagecontrolller
        let pageControllerHeight : CGFloat = 20
        let pageY = isTitleInTop ? bounds.size.height - pageControllerHeight : (bounds.size.height - pageControllerHeight - style.titleHeight)
        let pageControllerFrame = CGRect(x: 0, y: pageY, width: bounds.width, height: pageControllerHeight)
        pageControl = UIPageControl(frame: pageControllerFrame)
        pageControl.numberOfPages = 1
        pageControl.isEnabled = false
        pageControl.backgroundColor = UIColor.randomColor()
        addSubview(pageControl)
        
        // 创建collectionview
        let collectionY = isTitleInTop ? style.titleHeight : 0
        let collectionFrame = CGRect(x: 0, y: collectionY, width: bounds.width, height: bounds.height - style.titleHeight - pageControllerHeight)

        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.randomColor()
        
    }
}

extension HXPageCollectionView {
    
    func register(cell: AnyClass?, identifiler : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifiler)
    }
    func register(nib : UINib?, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

extension HXPageCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return dataSource?.numberOfSections(in: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCout = dataSource?.pageCollectionView(self, numberOfItemsInsection: section) ?? 0

        if  section == 0 {
            pageControl.numberOfPages = (itemCout - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCout
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
}

extension HXPageCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionview(self, didSelectItem: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewEndScroll()
    }
    
    fileprivate func scrollViewEndScroll() {
        // 1.取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            // 3.1.修改pageControl的个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInsection: indexPath.section) ?? 0
            
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 3.2.设置titleView位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            
            // 3.3.记录最新indexPath
            sourceIndexPath = indexPath
        }
        
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
}

extension HXPageCollectionView : HXTitleViewDelegate {
    func titleView(_ titleView: HXTitleView, selectedIndex index: Int) {
        
        let index = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: index, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
    }
}






