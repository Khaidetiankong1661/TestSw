//
//  EmoticonViewCell.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/4.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    var enmotion : Emoticon? {
        didSet {
            iconImageView.image = UIImage(named: (enmotion!.emoticonName))
        }
    }
}
