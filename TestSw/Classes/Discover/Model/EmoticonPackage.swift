//
//  EmoticonPackage.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/4.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

class EmoticonPackage {
    lazy var emotions : [Emoticon] = [Emoticon]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        guard let emotionArr = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        for str in emotionArr {
            emotions.append(Emoticon(emoticonName: str))
        }
    }
    
}
