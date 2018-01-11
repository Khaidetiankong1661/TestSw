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
    fileprivate lazy var socket : HXSocket = HXSocket(addr: "192.168.1.155", port: 7878)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if socket.connectServer() {
            socket.startReadMsg()
        }
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let msg = "你也好啊，李长江"
        let data = msg.data(using: .utf8)!
        
        var length = data.count
        
        let headerData = Data(bytes: &length, count: 4)
        
        let totalData = headerData + data
        
        
//        let msgData = Data(base64Encoded: msg)
//        socket.sendMsg(str: "你好啊 李银河")
        socket.sendMsg(data: totalData, type: 1)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ProfileViewController {
    func addSegmentView() {
        let vies = TextView.loadFromNib()
        
        view.addSubview(vies)
        
        let pageFrame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 250)
        
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
        view.addSubview(pageCollectionView)
        
    }
}


extension ProfileViewController : HXPageCollectionViewDataSource {
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

extension ProfileViewController : HXPageCollectionViewDelegate {
    func pageCollectionview(_ pageCollectionView: HXPageCollectionView, didSelectItem indexPath: IndexPath) {
        let emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emotions[indexPath.item]
        print(emoticon.emoticonName)
    }
}
