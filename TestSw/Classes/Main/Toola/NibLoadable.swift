//
//  NibLoadable.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/21.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit
// 面向协议开发
protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibName : String? = nil) -> Self {
        let loadName = nibName == nil ? "\(self)" : nibName!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
        
    }
    
}
