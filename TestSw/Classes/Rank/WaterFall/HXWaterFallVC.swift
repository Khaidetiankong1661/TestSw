//
//  HXWaterFallVC.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/20.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

private let kContenCellID = "kContenCellID"

class HXWaterFallVC: UIViewController {
    
    fileprivate lazy var collecitonView : UICollectionView = {
       
        let layout = HXWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        layout.dataSource = self
        
        let collectionview = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.dataSource = self
        
        return collectionview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collecitonView)
        collecitonView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContenCellID)
    }
}

extension HXWaterFallVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecitonView.dequeueReusableCell(withReuseIdentifier: kContenCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}

extension HXWaterFallVC : HXWaterfallLayoutDataSource {
    
    func numberOfCols(_ waterfall: HXWaterfallLayout) -> Int {
        return 3
    }
    func waterfall(_ waterfall: HXWaterfallLayout, item: Int) -> CGFloat {
       return CGFloat(arc4random_uniform(150) + 100)
        
    }

}

