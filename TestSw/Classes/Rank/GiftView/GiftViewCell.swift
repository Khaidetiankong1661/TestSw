//
//  GiftViewCell.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/5.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

class GiftViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var giftModel : GiftModel? {
        didSet {
//            iconImageView.setImage(giftModel?.img2, "room_btn_gift")
            iconImageView.image = UIImage(named: (giftModel?.img2)!)
            subjectLabel.text = giftModel?.subject
            priceLabel.text = "\(giftModel?.coin ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 5
        selectedView.layer.masksToBounds = true
        selectedView.layer.borderWidth = 1
        selectedView.layer.borderColor = UIColor.orange.cgColor
        selectedView.backgroundColor = UIColor.black
        
        selectedBackgroundView = selectedView
    }
}
