//
//  GiftPackage.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/5.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

class GiftPackage : BaseModel {
    var t : Int = 0
    var title : String = ""
    var list : [GiftModel] = [GiftModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            if let listArray = value as? [[String : Any]] {
                for listDict in listArray {
                    list.append(GiftModel(dict: listDict))
                }
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
