//
//  ProfileViewController.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/21.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

private let kEmoticonCell = "kEmoticonCellt"


class ProfileViewController: UIViewController , Emitterables {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let vies = TextView.loadFromNib()
        
        view.addSubview(vies)
        
        
        
        let pageFrame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        
        let titles = ["土豪", "热门", "专属", "常见"]
        let style = HXTitleStyle()
        style.isShowBottomLine = true
        
        let layout = HXWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.cols = 4
        layout.rows = 2
        
        let pageCollectionView = HXPageCollectionView(frame: pageFrame, titles: titles, style: style, isTitleInTop: false, layout: layout)
        
        pageCollectionView.dataSource = self
        pageCollectionView.register(cell: UICollectionViewCell.self, identifiler: kEmoticonCell)
        
        view.addSubview(pageCollectionView)
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        start()
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        stop()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ProfileViewController : HXPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: HXPageCollectionView) -> Int {
        return 3
    }
    func pageCollectionView(_ collectionView: HXPageCollectionView, numberOfItemsInsection section: Int) -> Int {
        if section == 0 {
            return 40
        } else {
            return 14
        }
    }
    func pageCollectionView(_ pageCollectionView: HXPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCell, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
}
