//
//  YMSettingHeaderView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/1.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

protocol YMSettingHeaderViewDelegate: NSObjectProtocol {
    func settingHeaderView(_ headerView: YMSettingHeaderView, accountManageButton: UIButton)
}

class YMSettingHeaderView: UIView {
    
    weak var delegate: YMSettingHeaderViewDelegate?
    
    class func settingHeaderView() -> YMSettingHeaderView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.last as! YMSettingHeaderView
    }
    
    @IBOutlet weak var accountManageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func accountManageButtonClick(_ sender: UIButton) {
        delegate?.settingHeaderView(self,  accountManageButton: sender)
    }
}
