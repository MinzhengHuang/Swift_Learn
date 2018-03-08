//
//  YMBlurImageView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/3.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  点击关注界面的某一个 cell 之后，跳转到下移控制器的顶部视图。
//  界面实现不算太难，主要是对每个控件的布局，使用 `SnapKit`。点击按钮的回调使用委托实现。
//

import UIKit
import SnapKit

protocol YMBlurImageViewDelegate: NSObjectProtocol {
    func blurImageView(_ blurImage: YMBlurImageView, titleButton: UIButton)
    func blurImageView(_ blurImage: YMBlurImageView, backButton: UIButton)
    func blurImageView(_ blurImage: YMBlurImageView, coverButton: UIButton)
    func blurImageView(_ blurImage: YMBlurImageView, shareButton: UIButton)
    func blurImageView(_ blurImage: YMBlurImageView, careButton: UIButton)
}
/// ![](http://obna9emby.bkt.clouddn.com/care-title.png)
class YMBlurImageView: UIImageView {
    
    weak var delegate: YMBlurImageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        // 添加毛玻璃效果
        addSubview(blurView)
        // 添加关注图片按钮
        addSubview(avaterImageView)
        // 添加标题
        addSubview(titltButton)
        // 添加关注人数
        addSubview(peopleCountLabel)
        // 添加帖子数量
        addSubview(topicCountLabel)
        // 添加介绍按钮
        addSubview(introduceButton)
        // 添加刷新图片
        addSubview(refreshImageView)
        // 添加覆盖按钮
        addSubview(coverButton)
        // 添加分享按钮
        addSubview(shareButton)
        // 添加关心按钮
        addSubview(careButton)
        // 添加返回按钮
        addSubview(backButton)
        
        coverButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(avaterImageView.snp.top).offset(-kMargin)
        }
        
        refreshImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton.snp.centerY)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerX.equalTo(self.centerX).offset(titltButton.width)
        }
        
        careButton.snp.makeConstraints { (make) in
            make.right.equalTo(shareButton.snp.left).offset(-kMargin)
            make.centerY.equalTo(backButton.snp.centerY)
            make.size.equalTo(CGSize(width: 53, height: 30))
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton.snp.centerY)
            make.right.equalTo(self).offset(-kMargin)
        }
        
        introduceButton.snp.makeConstraints { (make) in
            make.left.equalTo(topicCountLabel.snp.right).offset(kMargin)
            make.centerY.equalTo(topicCountLabel.snp.centerY)
        }
        
        topicCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(peopleCountLabel.snp.right).offset(kMargin)
            make.top.equalTo(peopleCountLabel.snp.top)
        }
        
        peopleCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titltButton.snp.left)
            make.bottom.equalTo(avaterImageView.snp.bottom).offset(-5)
        }
        
        titltButton.snp.makeConstraints { (make) in
            make.left.equalTo(avaterImageView.snp.right).offset(kMargin)
            make.top.equalTo(avaterImageView.snp.top).offset(5)
        }
        
        avaterImageView.snp.makeConstraints { (make) in
            make.left.equalTo(backButton)
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.bottom.equalTo(self.snp.bottom).offset(-15)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(3 * kMargin)
            make.left.equalTo(self).offset(15)
        }
        
        blurView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    // 中心刷新图标
    var refreshImageView: UIImageView = {
        let refreshImageView = UIImageView()
        refreshImageView.image = UIImage(named: "refresh_titlebar_20x20_")
        refreshImageView.alpha = 0
        return refreshImageView
    }()
    
    // 覆盖按钮
    lazy var coverButton: UIButton = {
        let coverButton = UIButton()
        coverButton.addTarget(self, action: #selector(coverButtonClick(_:)), for: .touchUpInside)
        return coverButton
    }()
    
    // 关心按钮
    fileprivate lazy var careButton: UIButton = {
        let careButton = UIButton()
        careButton.setTitle("关心", for: UIControlState())
        careButton.setTitle("已关心", for: .selected)
        careButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        careButton.setTitleColor(UIColor.white, for: UIControlState())
        careButton.setTitleColor(YMColor(230, g: 230, b: 230, a: 1.0), for: .selected)
        careButton.layer.borderColor = UIColor.white.cgColor
        careButton.layer.borderWidth = 1
        careButton.layer.cornerRadius = kCornerRadius
        careButton.layer.masksToBounds = true
        careButton.addTarget(self, action: #selector(careButtonClick(_:)), for: .touchUpInside)
        return careButton
    }()
    
    // 分享按钮
    fileprivate lazy var shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.setImage(UIImage(named: "icon_details_share_24x24_"), for: UIControlState())
        shareButton.setImage(UIImage(named: "icon_details_share_press_24x24_"), for: .highlighted)
        shareButton.addTarget(self, action: #selector(shareButtonClick(_:)), for: .touchUpInside)
        return shareButton
    }()
    
    // 介绍按钮
    lazy var introduceButton:  UIButton = {
        let introduceButton = UIButton()
        introduceButton.setTitle("介绍 >", for: UIControlState())
        introduceButton.setTitleColor(UIColor.white, for: UIControlState())
        introduceButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return introduceButton
    }()
    
    // 帖子数量
    lazy var topicCountLabel: UILabel = {
        let topicCountLabel = UILabel()
        topicCountLabel.text = "1000帖子"
        topicCountLabel.textColor = UIColor.white
        topicCountLabel.font = UIFont.systemFont(ofSize: 14)
        return topicCountLabel
    }()
    
    // 关注人数
    lazy var peopleCountLabel: UILabel = {
        let peopleCountLabel = UILabel()
        peopleCountLabel.text = "5679人关注"
        peopleCountLabel.textColor = UIColor.white
        peopleCountLabel.font = UIFont.systemFont(ofSize: 14)
        return peopleCountLabel
    }()
    
    // 标题
    lazy var titltButton: UIButton = {
        let titltButton = UIButton()
        titltButton.setTitle("# 数码宝贝", for: UIControlState())
        titltButton.setTitleColor(UIColor.white, for: UIControlState())
        titltButton.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        titltButton.addTarget(self, action: #selector(titltButtonClick(_:)), for: .touchUpInside)
        return titltButton
    }()
    
    // 关注图片
    var avaterImageView: UIImageView = {
        let avaterImageView = UIImageView()
        avaterImageView.image = UIImage(named: "hrscy")
        return avaterImageView
    }()
    
    // 返回按钮
    fileprivate lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "white_lefterbackicon_titlebar_28x28_"), for: UIControlState())
        backButton.addTarget(self, action: #selector(backButtonClick(_:)), for: .touchUpInside)
        backButton.sizeToFit()
        return backButton
    }()
    
    // 模糊效果
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    /// 返回按钮点击
    func backButtonClick(_ button: UIButton) {
        delegate?.blurImageView(self, backButton: button)
    }
    
    /// 标题按钮点击
    func titltButtonClick(_ button: UIButton) {
        delegate?.blurImageView(self, titleButton: button)
    }
    
    /// 分享按钮点击
    func shareButtonClick(_ button: UIButton) {
        delegate?.blurImageView(self, shareButton: button)
    }
    
    /// 关心按钮点击
    func careButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        delegate?.blurImageView(self, careButton: button)
    }
    
    /// 覆盖按钮点击
    func coverButtonClick(_ button: UIButton) {
        delegate?.blurImageView(self, coverButton: button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
