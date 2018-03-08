//
//  YMHomeTopicCell.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/9.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  主页新闻的 cell，其他四种类型的 cell 都继承自这个 cell
//  主要定义了 标题、头像、昵称、评论、关闭按钮
//

import UIKit
import SnapKit

class YMHomeTopicCell: UITableViewCell {
    
    var filterWords: [YMFilterWord]?
    
    var closeButtonClosure: ((_ filterWords: [YMFilterWord])->())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        addSubview(titleLabel)
        
        addSubview(avatarImageView)
        
        addSubview(nameLabel)
        
        addSubview(commentLabel)
        
        addSubview(timeLabel)
        
        addSubview(stickLabel)
        
        addSubview(closeButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(kHomeMargin)
            make.right.equalTo(self).offset(-kHomeMargin)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.bottom.equalTo(self.snp.bottom).offset(-kHomeMargin)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(5)
            make.centerY.equalTo(avatarImageView)
        }
        
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(nameLabel)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentLabel.snp.right).offset(5)
            make.centerY.equalTo(avatarImageView)
        }
        
        stickLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(5)
            make.centerY.equalTo(avatarImageView)
            make.height.equalTo(15)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(avatarImageView)
            make.size.equalTo(CGSize(width: 17, height: 12))
        }
    }
    
    /// 置顶，热，广告，视频
    lazy var stickLabel: UIButton = {
        let stickLabel = UIButton()
        stickLabel.isHidden = true
        stickLabel.layer.cornerRadius = 3
        stickLabel.sizeToFit()
        stickLabel.isUserInteractionEnabled = false
        stickLabel.titleLabel!.font = UIFont.systemFont(ofSize: 12)
        stickLabel.setTitleColor(YMColor(241, g: 91, b: 94, a: 1.0), for: UIControlState())
        stickLabel.layer.borderColor = YMColor(241, g: 91, b: 94, a: 1.0).cgColor
        stickLabel.layer.borderWidth = 0.5
        return stickLabel
    }()
    
    /// 新闻标题
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    /// 用户名头像
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        return avatarImageView
    }()
    
    /// 用户名
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.lightGray
        return nameLabel
    }()
    
    /// 评论
    lazy var commentLabel: UILabel = {
        let comentLabel = UILabel()
        comentLabel.font = UIFont.systemFont(ofSize: 12)
        comentLabel.textColor = UIColor.lightGray
        return comentLabel
    }()
    
    /// 时间
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.lightGray
        return timeLabel
    }()
    
    /// 举报按钮
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "add_textpage_17x12_"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return closeButton
    }()
    
    /// 举报按钮点击
    func closeBtnClick() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
