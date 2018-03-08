//
//  YMsearchCell.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/2.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

class YMsearchCell: UITableViewCell {

    var searchText: String?
    
    var keyword: YMKeyword? {
        didSet {
            let count = searchText?.characters.count
            let index = keyword!.keyword?.characters.index((keyword!.keyword?.startIndex)!, offsetBy: count!)
            let subString = keyword!.keyword?.substring(from: index!)
            let attributeString = NSMutableAttributedString(string: searchText!, attributes: [NSForegroundColorAttributeName: YMColor(232, g: 84, b: 85, a: 1.0)])
            let subAttributeString = NSAttributedString(string: subString!)
            attributeString.append(subAttributeString)
            keywordLabel.attributedText = attributeString
        }
    }
    
    @IBOutlet weak var keywordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
