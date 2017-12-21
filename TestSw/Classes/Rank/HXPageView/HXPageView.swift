
//
//  HXPageView.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/12.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

class HXPageView: UIView {

    fileprivate var titles : [String]
    fileprivate var childVCs : [UIViewController]
    fileprivate var parendVC : UIViewController!
    fileprivate var style : HXTitleStyle
    
    fileprivate var titleView : HXTitleView!
    fileprivate var contentView : HXContentView!

    init(frame: CGRect, titles: [String], childVCs : [UIViewController], parentVC : UIViewController, style : HXTitleStyle) {
        
//        assert(titles.count == childVCs.count, "标题&控制器个数不同,请检测!!!")
        self.titles = titles
        self.childVCs = childVCs
        self.parendVC = parentVC
        self.style = style
        parentVC.automaticallyAdjustsScrollViewInsets = false
        
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HXPageView {
    
    fileprivate func setUpUI() {
        let titleH : CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleH)
        titleView = HXTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
        titleView.backgroundColor = UIColor.randomColor()
        
        
        let contentFrame = CGRect(x: 0, y: titleH, width: bounds.width, height: bounds.height - titleH)
        contentView = HXContentView(frame: contentFrame, childrenVC: childVCs, parendVC: parendVC)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        contentView.delegatet = self
        addSubview(contentView)
        contentView.backgroundColor = UIColor.randomColor()
        
    }
}

// MARK:- 设置HYContentView的代理
extension HXPageView : HXContentViewDelegate {

    func contentView(_ contentView: HXContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: HXContentView) {
        titleView.contentViewDidEndScroll()
    }
}


// MARK:- 设置HYTitleView的代理
extension HXPageView : HXTitleViewDelegate {

    func titleView(_ titleView: HXTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}

