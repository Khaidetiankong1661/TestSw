
//
//  HXContentView.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/12.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

private let identifierID = "identifierID"

class HXContentView: UIView {

    fileprivate var childrenVC : [UIViewController]
    fileprivate var parentVC : UIViewController
    
    fileprivate lazy var collectionView : UICollectionView =  {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
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

