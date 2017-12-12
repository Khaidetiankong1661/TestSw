//
//  RankViewController.swift
//
//

import UIKit

class RankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        let titles = ["游戏", "娱乐娱乐娱乐", "趣玩", "美女女", "颜值颜值", "趣玩", "美女女", "颜值颜值"]
        let style = HXTitleStyle()
        style.isScrollEnable = true

        var children = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            children.append(vc)
        }
        
        // 3.pageView的frame
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        // 4.创建HYPageView,并且添加到控制器的view中
        let pageView = HXPageView(frame: pageFrame, titles: titles, childVCs: children, parentVC: self, style: style)
        view.addSubview(pageView)
    }

}
