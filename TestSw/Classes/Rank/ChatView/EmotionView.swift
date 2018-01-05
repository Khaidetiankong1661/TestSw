//
//  EmotionView.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/4.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit
private let kEmoticonCell = "kEmoticonCellt"

class EmotionView: UIView {

    var emotionClickCallBlock : ((Emoticon) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmotionView {
    fileprivate func setUpUI() {
        let pageFrame = self.bounds
        
        let titles = ["普通", "粉丝专属"]
        let style = HXTitleStyle()
        style.isShowBottomLine = true
        
        let layout = HXWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.cols = 7
        layout.rows = 3
        
        let pageCollectionView = HXPageCollectionView(frame: pageFrame, titles: titles, style: style, isTitleInTop: false, layout: layout)
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        //        pageCollectionView.register(cell: UICollectionViewCell.self, identifiler: kEmoticonCell)
        pageCollectionView.register(nib: UINib(nibName:"EmoticonViewCell", bundle: nil), identifier: kEmoticonCell)
        addSubview(pageCollectionView)
    }
}

extension EmotionView : HXPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: HXPageCollectionView) -> Int {
        return EmoticonViewModel.shareInstance.packages.count
    }
    func pageCollectionView(_ collectionView: HXPageCollectionView, numberOfItemsInsection section: Int) -> Int {
        return EmoticonViewModel.shareInstance.packages[section].emotions.count
    }
    func pageCollectionView(_ pageCollectionView: HXPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCell, for: indexPath) as!EmoticonViewCell
        //        cell.backgroundColor = UIColor.randomColor()
        cell.enmotion = EmoticonViewModel.shareInstance.packages[indexPath.section].emotions[indexPath.item]
        return cell
    }
}

extension EmotionView : HXPageCollectionViewDelegate {
    func pageCollectionview(_ pageCollectionView: HXPageCollectionView, didSelectItem indexPath: IndexPath) {
        let emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emotions[indexPath.item]
        
        if let emotionClickCallBlock = emotionClickCallBlock {
            emotionClickCallBlock(emoticon)
        }
    }
}
