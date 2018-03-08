//
//  YMUserHeaderView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/14.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  用户顶部 view
//  暂时没有使用

import UIKit
import Kingfisher

/// ![](http://obna9emby.bkt.clouddn.com/news/video-detail-user-header.png)
class YMUserHeaderView: UIView {
    
    var media: YMMediaEntry? {
        didSet {
            let url = media?.icon
//            avatarImageView.kf.setImageWithURL(URL(string: url!)!)
            avatarImageView.kf.setImage(with: url as! Resource?)
//            avatarImageView.kf_setImageWithURL(URL(string: url!)!, placeholderImage: UIImage(named: "home_head_default_29x29_"), optionsInfo: nil, progressBlock: { (receivedSize, totalSize) in
//                self.progressView.width = SCREENW * CGFloat(receivedSize / totalSize)
//                })
//                { (image, error, cacheType, imageURL) in
//                    self.progressView.isHidden = true
//            }
            avatarImageView.kf.setImage(with: url as! Resource?, placeholder: UIImage(named: "home_head_default_29x29_"), options: nil, progressBlock: { (receivedSize, totalSize) in
                self.progressView.width = SCREENW * CGFloat(receivedSize / totalSize)
                self.progressView.isHidden = true
            }, completionHandler: nil)
            nameLabel.text = media?.name
            introduceLabel.text = media?.describe
            careButton.isSelected = media!.is_subscribed
        }
    }
    
    /// 返回按钮点击回调
    var backButtonClosure: (()->())?
    /// 关注按钮点击回调
    var careButtonClosure: ((_ button: UIButton)->())?
    /// 更多按钮点击回调
    var moreButtonClosure: (() -> ())?
    /// 全部按钮点击回调
    var allButtonClosure: (() -> ())?
    /// 视频按钮点击回调
    var videoButtonClosure: (() -> ())?
    
    class func userHeaderView() -> YMUserHeaderView {
        let frame = CGRect(x: 0, y: 0, width: SCREENW, height: 278)
        return YMUserHeaderView(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    func setupUI() {
        
        /// 添加头像，昵称，介绍
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(introduceLabel)
        /// 添加底部 view
        addSubview(lineView1)
        addSubview(bottomView)
        addSubview(lineView2)
        /// 添加 全部按钮，视频按钮
        bottomView.addSubview(allButton)
        bottomView.addSubview(videoButton)
        bottomView.addSubview(redView)
        /// 添加顶部View
        addSubview(topView)
        topView.addSubview(progressView)
        /// 添加返回按钮，关注按钮，更多按钮
        addSubview(backButton)
        addSubview(careButton)
        addSubview(moreButton)
        
        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView)
            make.size.equalTo(CGSize(width: 100, height: 2))
            make.top.equalTo(topView.snp.top).offset(20)
        }
        
        redView.snp.makeConstraints { (make) in
            make.centerX.equalTo(videoButton)
            make.size.equalTo(CGSize(width: 40, height: 2))
            make.bottom.equalTo(lineView2.snp.top)
        }
        
        allButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(bottomView)
            make.right.equalTo(videoButton.snp.left)
            make.width.equalTo(SCREENW * 0.5)
        }
        
        videoButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(bottomView)
            make.width.equalTo(allButton)
        }
        
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(klineWidth)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(44)
            make.top.equalTo(introduceLabel.snp.bottom).offset(kMargin)
        }
        
        lineView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(klineWidth)
            make.top.equalTo(bottomView.snp.bottom)
        }
        
        introduceLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(SCREENW - 40)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.bottom.equalTo(bottomView.snp.top).offset(-kMargin)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.equalTo(25)
            make.top.equalTo(avatarImageView.snp.bottom).offset(kMargin)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 66, height: 66))
            make.top.equalTo(topView.snp.bottom).offset(20)
        }
        
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(-20)
            make.height.equalTo(64)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView).offset(kMargin)
            make.left.equalTo(topView).offset(kHomeMargin)
        }
        
        careButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton)
            make.size.equalTo(CGSize(width: 52, height: 28))
            make.right.equalTo(moreButton.snp.left).offset(-kMargin)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(careButton)
            make.right.equalTo(topView.snp.right).offset(-kMargin)
        }
    }
    
    fileprivate lazy var progressView: UIView = {
        let progressView = UIView()
        progressView.backgroundColor = YMColor(42, g: 145, b: 215, a: 1.0)
        return progressView
    }()
    
    /// 顶部View
    lazy var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        return topView
    }()
    
    /// 返回按钮
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "lefterbackicon_titlebar_28x28_"), for: UIControlState())
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return backButton
    }()
    
    /// 关注按钮
    lazy var careButton: UIButton = {
        let careButton = UIButton()
        careButton.setTitle("关注", for: UIControlState())
        careButton.setTitle("已关注", for: .selected)
        careButton.setTitleColor(UIColor.black, for: UIControlState())
        careButton.setTitleColor(UIColor.lightGray, for: .selected)
        careButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        careButton.layer.cornerRadius = kCornerRadius
        careButton.layer.masksToBounds = true
        careButton.layer.borderColor = UIColor.black.cgColor
        careButton.layer.borderWidth = klineWidth
        careButton.addTarget(self, action: #selector(careButtonClick(_:)), for: .touchUpInside)
        return careButton
    }()
    
    /// 更多按钮
    lazy var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.setImage(UIImage(named: "new_more_titlebar_28x28_"), for: UIControlState())
        moreButton.sizeToFit()
        moreButton.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        return moreButton
    }()
    
    /// 头像
    fileprivate lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "home_head_default_29x29_")
        avatarImageView.layer.cornerRadius = 33
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        avatarImageView.layer.borderWidth = 0.5
        return avatarImageView
    }()
    
    /// 用户昵称
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    /// 介绍
    fileprivate lazy var introduceLabel: UILabel = {
        let introduceLabel = UILabel()
        introduceLabel.numberOfLines = 0
        introduceLabel.font = UIFont.systemFont(ofSize: 13)
        introduceLabel.textColor = UIColor.lightGray
        introduceLabel.textAlignment = .center
        return introduceLabel
    }()
    
    /// 分割线
    fileprivate lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = YMColor(220, g: 220, b: 220, a: 1.0)
        return lineView1
    }()
    
    /// 底部 View
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        return bottomView
    }()
    
    /// 全部按钮
    lazy var allButton: UIButton = {
        let allButton = UIButton()
        allButton.setTitle("全部", for: UIControlState())
        allButton.setTitleColor(UIColor.black, for: UIControlState())
        allButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        allButton.addTarget(self, action: #selector(allButtonClick(_:)), for: .touchUpInside)
        return allButton
    }()
    
    /// 视频按钮
    lazy var videoButton: UIButton = {
        let videoButton = UIButton()
        videoButton.setTitle("视频", for: UIControlState())
        videoButton.isSelected = true
        videoButton.setTitleColor(UIColor.black, for: UIControlState())
        videoButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        videoButton.addTarget(self, action: #selector(videoButtonClick(_:)), for: .touchUpInside)
        return videoButton
    }()
    
    /// 红色指示线
    fileprivate lazy var redView: UIView = {
        let redView = UIView()
        redView.backgroundColor = YMColor(246, g: 68, b: 64, a: 1.0)
        return redView
    }()
    
    /// 分割线
    fileprivate lazy var lineView2: UIView = {
        let lineView2 = UIView()
        lineView2.backgroundColor = YMColor(220, g: 220, b: 220, a: 1.0)
        return lineView2
    }()
    
    /// 返回按钮点击
    func backButtonClick() {
        backButtonClosure?()
    }
    
    /// 关注按钮点击
    func careButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        button.layer.borderColor = button.isSelected ? UIColor.lightGray.cgColor : UIColor.black.cgColor
        careButtonClosure?(button)
    }
    
    /// 更多按钮点击
    func moreButtonClick() {
        moreButtonClosure?()
    }
    
    /// 全部按钮点击
    func allButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: kAnimationDuration, animations: { 
            self.redView.centerX = button.centerX
            }, completion: { (_) in
                self.allButtonClosure?()
        }) 
    }
    
    /// 视频按钮点击
    func videoButtonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.redView.centerX = button.centerX
        }, completion: { (_) in
            self.videoButtonClosure?()
        }) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
