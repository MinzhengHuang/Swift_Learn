//
//  YMHomeNoImageCell.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/9.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  没有图片的情况
//

import UIKit
/// ![](http://obna9emby.bkt.clouddn.com/home-cell-1.png)
class YMHomeNoImageCell: YMHomeTopicCell {
    
    var newsTopic: YMNewsTopic? {
        didSet{
            titleLabel.text = String(newsTopic!.title!)
            if let publishTime = newsTopic?.publish_time {
                timeLabel.text = NSString.changeDateTime(publishTime)
            }
            
            if let sourceAvatar = newsTopic?.source_avatar {
                nameLabel.text = newsTopic!.source
                avatarImageView.setCircleHeader(sourceAvatar)
            }
            
            if let mediaInfo = newsTopic!.media_info {
                nameLabel.text = mediaInfo.name
                avatarImageView.setCircleHeader(mediaInfo.avatar_url!)
            }
            
            if let commentCount = newsTopic!.comment_count {
                commentCount >= 10000 ? (commentLabel.text = "\(commentCount / 10000)万评论") : (commentLabel.text = "\(commentCount)评论")
            } else {
                commentLabel.isHidden = true
            }
            
            filterWords = newsTopic?.filter_words
            if let label = newsTopic?.label {
                stickLabel.setTitle(" \(label) ", for: UIControlState())
                stickLabel.isHidden = false
                closeButton.isHidden = (label == "置顶") ?  true : false
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
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
