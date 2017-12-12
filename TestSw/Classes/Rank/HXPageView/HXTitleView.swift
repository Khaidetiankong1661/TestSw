//
//  HXTitleView.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/12.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

class HXTitleView: UIView {

    fileprivate var titles : [String]
    fileprivate var style : HXTitleStyle
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    init(frame: CGRect, titles : [String], style : HXTitleStyle) {
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        setUPUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HXTitleView {
    
    fileprivate func setUPUI() {
    
        addSubview(scrollView)
        setUpTitleLabels()
        setUPTitleLabelFrames()
    }
    
    private func setUpTitleLabels() {
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selecColor : style.normalColor
            
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
        }
    }
    
    private func setUPTitleLabelFrames() {
        
        let cout = titles.count
        
        for (i, label) in titleLabels.enumerated() {
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            if style.isScrollEnable {

                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : label.font], context: nil).width
                
                if i == 0 {
                    x = style.itemMargin * 0.5
                } else {
                    let labe = titleLabels[i - 1]
                    x = labe.frame.maxX + style.itemMargin
                }
            } else {
                w = bounds.width / CGFloat(cout)
                x = w * CGFloat(i)
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}








