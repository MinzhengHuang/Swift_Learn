//
//  YMOfflineCell.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/15.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

class YMOfflineCell: UITableViewCell {

    var topTitle: YMHomeTopTitle? {
        didSet {
            nameLabel.text = topTitle?.name
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
