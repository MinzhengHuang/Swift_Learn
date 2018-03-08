//
//  YMHomeMiddleCell.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/8.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  右边显示一张图片的情况
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

/// ![右边显示一张图片的情况](http://obna9emby.bkt.clouddn.com/home-cell-4.png)
class YMHomeMiddleCell: YMHomeTopicCell {
    
    var newsTopic: YMNewsTopic? {
        didSet{
            titleLabel.text = String(newsTopic!.title!)
            timeLabel.text = NSString.changeDateTime(newsTopic!.publish_time!)
            if let sourceAvatar = newsTopic?.source_avatar {
                nameLabel.text = newsTopic!.source
                avatarImageView.setCircleHeader(sourceAvatar)
                rightImageView.kf.setImage(with: URL(string: sourceAvatar)!)
            }
            
            if let mediaInfo = newsTopic!.media_info {
                nameLabel.text = mediaInfo.name
                avatarImageView.setCircleHeader(mediaInfo.avatar_url!)
                rightImageView.kf.setImage(with: URL(string: mediaInfo.avatar_url!)!)
            }
            
            if let commentCount = newsTopic!.comment_count {
                commentCount >= 10000 ? (commentLabel.text = "\(commentCount / 10000)万评论") : (commentLabel.text = "\(commentCount)评论")
            } else {
                commentLabel.isHidden = true
            }
            
            if (newsTopic!.titleH + avatarImageView.height + kMargin) < newsTopic?.imageH {
                closeButton.snp.remakeConstraints({ (make) in
                    make.right.equalTo(rightImageView.snp.left).offset(-kHomeMargin)
                    make.centerY.equalTo(avatarImageView)
                    make.size.equalTo(CGSize(width: 17, height: 12))
                })
            }
            filterWords = newsTopic?.filter_words
            let url = newsTopic!.middle_image?.url
            rightImageView.kf.setImage(with: URL(string: url!)!)
            
            if let label = newsTopic?.label {
                stickLabel.setTitle(" \(label) ", for: UIControlState())
                stickLabel.isHidden = false
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(rightImageView)
        
        addSubview(timeButton)
        
        timeButton.snp.makeConstraints { (make) in
            make.right.equalTo(rightImageView.snp.right).offset(-5)
            make.bottom.equalTo(rightImageView.snp.bottom).offset(-5)
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(kHomeMargin)
            make.size.equalTo(CGSize(width: 108, height: 70))
            make.right.equalTo(self).offset(-kHomeMargin)
        }
        
        titleLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(rightImageView.snp.left).offset(-kHomeMargin)
            make.left.top.equalTo(self).offset(kHomeMargin)
        }
    }
    
    /// 右下角的视频时长
    fileprivate lazy var timeButton: UIButton = {
        let timeButton = UIButton()
        timeButton.isHidden = true
        timeButton.isUserInteractionEnabled = false
        timeButton.layer.cornerRadius = 8
        timeButton.layer.masksToBounds = true
        timeButton.setTitleColor(UIColor.white, for: UIControlState())
        timeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        timeButton.setImage(UIImage(named: "palyicon_video_textpage_7x10_"), for: UIControlState())
        return timeButton
    }()
    
    /// 右边图片
    fileprivate lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.backgroundColor = UIColor.lightGray
        return rightImageView
    }()
    
    /// 举报按钮点击
    override func closeBtnClick() {
        closeButtonClosure?(filterWords!)
    }
    
    /// 举报按钮点击回调
    func closeButtonClick(_ closure:@escaping (_ filterWord: [YMFilterWord])->()) {
        closeButtonClosure = closure
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
