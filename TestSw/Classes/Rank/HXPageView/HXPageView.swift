
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
    fileprivate var parendVC : UIViewController
    fileprivate var style : HXTitleStyle
    
    fileprivate var titleView : HXTitleView!
    
    init(frame: CGRect, titles: [String], childVCs : [UIViewController], parentVC : UIViewController, style : HXTitleStyle) {
        self.titles = titles
        self.childVCs = childVCs
        self.parendVC = parentVC
        self.style = style
        
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HXPageView {
    
    fileprivate func setUpUI() {
        setUPTitleViewUI()
        setUPContenView()
    }
    
    private func setUPTitleViewUI() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = HXTitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.backgroundColor = UIColor.randomColor()
    }
    
    private func setUPContenView() {
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight - 44)
        let contenView = HXContentView(frame: contentFrame, childrenVC: childVCs, parendVC: parendVC)

        addSubview(contenView)
        contenView.backgroundColor = UIColor.randomColor()
        
        titleView.delegate = contenView
        contenView.delegatet = titleView

    }
}

