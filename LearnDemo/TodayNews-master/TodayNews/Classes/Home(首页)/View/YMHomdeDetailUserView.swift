//
//  YMHomdeDetailUserView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/12.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  新闻详情标题下面的关注用户
//  没有调用
//

import UIKit
import SnapKit
/// ![](http://obna9emby.bkt.clouddn.com/news/home-detail-care.png)
class YMHomdeDetailUserView: UIView {
    
    var newTopic: YMNewsTopic? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        addSubview(avatarImage)
        
        addSubview(titleLabel)
        
        addSubview(typeButton)
        
        addSubview(timeLabel)
        
        addSubview(careButton)
        
        careButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 72, height: 29))
            make.right.equalTo(self).offset(-kHomeMargin)
            make.centerY.equalTo(avatarImage)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeButton).offset(5)
            make.centerY.equalTo(typeButton)
        }
        
        typeButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(avatarImage.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImage).offset(kMargin)
            make.top.equalTo(avatarImage)
        }
        
        avatarImage.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(kHomeMargin)
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.centerY.equalTo(self)
        }
        
    }
    
    /// 关注按钮
    fileprivate lazy var careButton: UIButton = {
        let careButton = UIButton()
        careButton.setTitle("+ 关注", for: UIControlState())
        careButton.setTitleColor(UIColor.white, for: UIControlState())
        careButton.backgroundColor = YMColor(42, g: 145, b: 215, a: 1.0)
        careButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        careButton.layer.cornerRadius = kCornerRadius
        careButton.layer.masksToBounds = true
        return careButton
    }()
    
    /// 时间
    fileprivate lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        return timeLabel
    }()
    
    /// 类型按钮
    fileprivate lazy var typeButton: UIButton = {
        let typeButton = UIButton()
        typeButton.isUserInteractionEnabled = false
        typeButton.sizeToFit()
        typeButton.setTitle("原创", for: UIControlState())
        typeButton.setTitleColor(YMColor(76, g: 148, b: 200, a: 1.0), for: UIControlState())
        typeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        typeButton.layer.cornerRadius = 5
        typeButton.layer.masksToBounds = true
        typeButton.layer.borderColor = YMColor(76, g: 148, b: 200, a: 1.0).cgColor
        typeButton.layer.borderWidth = klineWidth
        return typeButton
    }()
    
    /// 标题按钮
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        return titleLabel
    }()
    
    /// 头像
    fileprivate lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.backgroundColor = YMGlobalColor()
        return avatarImage
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
