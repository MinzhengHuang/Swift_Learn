//
//  YMMineHeaderIconButton.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/30.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  我的界面-> 头部 view -> 头像按钮
//

import UIKit

class YMMineHeaderIconButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setTitleColor(UIColor.white, for: UIControlState())
        imageView?.layer.cornerRadius = 30
        imageView?.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 调整图片
        imageView?.x = kMargin
        imageView?.y = 0
        imageView?.width = 60
        imageView?.height = imageView!.width
        // 调整文字
        titleLabel?.x = 0
        titleLabel?.y = imageView!.height + kMargin
        titleLabel?.width = self.width
        titleLabel?.height = 2 * kMargin
    }
    
}
