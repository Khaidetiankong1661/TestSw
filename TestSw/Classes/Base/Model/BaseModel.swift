//
//  BaseModel.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/5.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

class BaseModel : NSObject {
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
