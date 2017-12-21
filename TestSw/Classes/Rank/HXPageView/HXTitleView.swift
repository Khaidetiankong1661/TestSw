//
//  HXTitleView.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/12.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

protocol HXTitleViewDelegate : class {
    func titleView(_ titleView : HXTitleView, selectedIndex index : Int)

}

class HXTitleView: UIView {
    
    weak var delegate : HXTitleViewDelegate?

    fileprivate var titles : [String]
    fileprivate var style : HXTitleStyle
    
    fileprivate lazy var currentIndex : Int = 0
    
    // MARK: 计算属性
    fileprivate lazy var normalColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.normalColor)
    
    fileprivate lazy var selectedColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.selectedColor)
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine : UIView = {
      let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineH
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineH
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
        
        // 4.设置Label的位置
        setupTitleLabelsPosition()
        
        if style.isShowBottomLine {
            scrollView.addSubview(bottomLine)
        }
    }
    
    private func setUpTitleLabels() {
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = style.font
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectedColor : style.normalColor
            
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    
    fileprivate func setupTitleLabelsPosition() {
        
        var titleX: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        let titleH : CGFloat = frame.height
        
        let count = titles.count
        
        for (index, label) in titleLabels.enumerated() {
            if style.isScrollEnable {
                let rect = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : style.font], context: nil)
                titleW = rect.width
                if index == 0 {
                    titleX = style.titleMargin * 0.5
                } else {
                    let preLabel = titleLabels[index - 1]
                    titleX = preLabel.frame.maxX + style.titleMargin
                }
                
            } else {
                titleW = frame.width / CGFloat(count)
                titleX = titleW * CGFloat(index)
            }
            
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
//            // 放大的代码
//            if index == 0 {
//                let scale = style.isNeedScale ? style.scaleRange : 1.0
//                label.transform = CGAffineTransform(scaleX: scale, y: scale)
//            }
        }
        
        if style.isScrollEnable {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
    }
}

extension HXTitleView {
    @objc fileprivate func titleLabelClick(_ tap : UITapGestureRecognizer) {
        // 0.获取当前Label
        guard let currentLabel = tap.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = style.selectedColor
        oldLabel.textColor = style.normalColor
        
        // 4.保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        // 5.通知代理
        delegate?.titleView(self, selectedIndex: currentIndex)
        
        // 6.居中显示
        contentViewDidEndScroll()
        
        // 7.调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.bottomLine.frame.size.width = currentLabel.frame.size.width
            })
        }
        
//        // 8.调整比例
//        if style.isNeedScale {
//            oldLabel.transform = CGAffineTransform.identity
//            currentLabel.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
//        }
        
        // 9.遮盖移动
//        if style.isShowCover {
//            let coverX = style.isScrollEnable ? (currentLabel.frame.origin.x - style.coverMargin) : currentLabel.frame.origin.x
//            let coverW = style.isScrollEnable ? (currentLabel.frame.width + style.coverMargin * 2) : currentLabel.frame.width
//            UIView.animate(withDuration: 0.15, animations: {
//                self.coverView.frame.origin.x = coverX
//                self.coverView.frame.size.width = coverW
//            })
//        }
    }
}


// MARK:- 获取RGB的值
extension HXTitleView {
    fileprivate func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给Title赋值颜色")
        }
        
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

// MARK:- 对外暴露的方法
extension HXTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0, selectedColorRGB.1 - normalColorRGB.1, selectedColorRGB.2 - normalColorRGB.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - colorDelta.0 * progress, g: selectedColorRGB.1 - colorDelta.1 * progress, b: selectedColorRGB.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: normalColorRGB.0 + colorDelta.0 * progress, g: normalColorRGB.1 + colorDelta.1 * progress, b: normalColorRGB.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
        
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        
        // 5.计算滚动的范围差值
        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
        }
        
        // 6.放大的比例
//        if style.isNeedScale {
//            let scaleDelta = (style.scaleRange - 1.0) * progress
//            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
//            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
//        }
        
//        // 7.计算cover的滚动
//        if style.isShowCover {
//            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.width + moveTotalW * progress)
//            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress)
//        }
    }
    
    func contentViewDidEndScroll() {
        // 0.如果是不需要滚动,则不需要调整中间位置
        guard style.isScrollEnable else { return }
        
        // 1.获取获取目标的Label
        let targetLabel = titleLabels[currentIndex]
        
        // 2.计算和中间位置的偏移量
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        
        // 3.滚动UIScrollView
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
}




//extension HXTitleView : HXContentViewDelegate {
//    func contenView(_ contentView: HXContentView, targetIndex: Int) {
//        adjustTitleLabel(targetIndex: targetIndex)
//    }
//
//    func contenView(_ contentView: HXContentView, targetIndex: Int, progress: CGFloat) {
//
//        // 1.取出Label
//        let targetLabel = titleLabels[targetIndex]
//        let sourceLabel = titleLabels[currentIndex]
//
//        // 2.颜色渐变
//        let deltaRGB = UIColor.getRGBDelta(style.selecColor, style.normalColor)
//        let selectRGB = style.selecColor.getRGB()
//        let normalRGB = style.normalColor.getRGB()
//        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
//        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
//
//        // 3.bottomLine渐变过程
//        if style.isShowScrollLine {
//            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
//            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
//            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
//            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
//        }
//    }
//
//
//}





