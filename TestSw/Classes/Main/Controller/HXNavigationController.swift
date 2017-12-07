

//
//  HXNavigationController.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/7.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

class HXNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
