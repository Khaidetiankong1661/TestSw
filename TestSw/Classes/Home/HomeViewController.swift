//
//  HomeViewController.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/7.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        view.backgroundColor = UIColor.init(r: 230, g: 210, b: 24, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension HomeViewController {
    fileprivate func setUpUI() {
        setNavigationBar()
    }
    private func setNavigationBar() {
        let name = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: name, style: .plain, target: self, action: #selector(leftItem))
        
        let rightName = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightName, style: .plain, target: self, action: #selector(rightItem))
        
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let search = UISearchBar(frame: searchFrame)
        search.placeholder = "placelPalceHoder"
        navigationItem.titleView = search
        search.searchBarStyle = .minimal
        let searchFiled = search.value(forKey: "_searchField")as?  UITextField
        searchFiled?.textColor = UIColor.white
        
        
    }
    
}

extension HomeViewController {
   @objc fileprivate func leftItem() {
        
    }
    
   @objc fileprivate func rightItem() {
        
    }
    
}




