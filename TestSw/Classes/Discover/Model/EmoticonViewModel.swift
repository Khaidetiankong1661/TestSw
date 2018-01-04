//
//  EmoticonViewModel.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/4.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

class EmoticonViewModel {
    static let shareInstance : EmoticonViewModel = EmoticonViewModel()
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
}
