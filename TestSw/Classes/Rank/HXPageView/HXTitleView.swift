//
//  HXTitleView.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/12.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

protocol HXTitleViewDelegate : class {
    func titleView(_ titleview : HXTitleView, target : Int)
}

class HXTitleView: UIView {
    
    weak var delegate : HXTitleViewDelegate?

    fileprivate var titles : [String]
    fileprivate var style : HXTitleStyle
    
    fileprivate lazy var currentIndex : Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine : UIView = {
      let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return bottomLine
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
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
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
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
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
                    if style.isShowScrollLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                } else {
                    let labe = titleLabels[i - 1]
                    x = labe.frame.maxX + style.itemMargin
                }
            } else {
                w = bounds.width / CGFloat(cout)
                x = w * CGFloat(i)
                
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}

extension HXTitleView {
    @objc fileprivate func titleClick(_ tapGes : UITapGestureRecognizer) {
        let targetLabel = tapGes.view as! UILabel
        
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        // 3.调整bottomLine
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
        
        delegate?.titleView(self, target: currentIndex)
    }
    
    fileprivate func adjustTitleLabel(targetIndex : Int) {
        
        if targetIndex == currentIndex { return }
        // 1.取出Label
        let targetLabel = titleLabels[targetIndex]
        let courceLabel = titleLabels[currentIndex]
        
        targetLabel.textColor = style.selecColor
        courceLabel.textColor = style.normalColor
        
        currentIndex = targetIndex

        if style.isScrollEnable {
            
            var offSetX = targetLabel.center.x - scrollView.bounds.width * 0.5
            if offSetX < 0 {
                offSetX = 0
            }
            if offSetX > (scrollView.contentSize.width - scrollView.bounds.width) {
                offSetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x : offSetX, y : 0), animated: true)
        }
    }
}


extension HXTitleView : HXContentViewDelegate {
    func contenView(_ contentView: HXContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    func contenView(_ contentView: HXContentView, targetIndex: Int, progress: CGFloat) {
        
        // 1.取出Label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 2.颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selecColor, style.normalColor)
        let selectRGB = style.selecColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        
        // 3.bottomLine渐变过程
        if style.isShowScrollLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
    }
    
    
}





