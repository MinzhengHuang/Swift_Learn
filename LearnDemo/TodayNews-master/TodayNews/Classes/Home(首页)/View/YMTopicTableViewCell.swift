//
//  YMTopicTableViewCell.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/4.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  这个类没有调用，使用一个类显示 5 种 cell，但是显示有问题
//

import UIKit
import SnapKit
///  这个类没有调用，可以对比 **YMHomeTopicCell,YMHomeNoImageCell,YMHomeLargeCell,YMHomeMiddleCell,YMHomeSmallCell**
class YMTopicTableViewCell: UITableViewCell {
    
    var filterWords: [YMFilterWord]?
    
    var closeButtonClosure: ((_ filterWords: [YMFilterWord])->())?
    
    var newsTopic: YMNewsTopic? {
        didSet{
            titleLabel.text = String(newsTopic!.title!)
            let mediaInfo = newsTopic!.media_info
            // mediaInfo 不为空，source_avatar 不一定存在，source_avatar 不为空，mediaInfo 也不一定存在
            if newsTopic!.source_avatar != nil {
                nameLabel.text = newsTopic!.source
                avatarImageView.setCircleHeader(newsTopic!.source_avatar!)
            }
            
            if mediaInfo?.name != nil {
                nameLabel.text = mediaInfo?.name
                avatarImageView.setCircleHeader(mediaInfo!.avatar_url!)
            }
            
            if newsTopic!.comment_count! >= 10000 {
                let comment_count = newsTopic!.comment_count! / 10000
                commentLabel.text = "\(comment_count)万条评论"
            } else {
                commentLabel.text = "\(newsTopic!.comment_count!)条评论"
            }
            closeButton.isHidden = (newsTopic?.stick_label == "置顶") ? true : false
            filterWords = newsTopic?.filter_words
            
            if newsTopic!.image_list.count != 0 {

                rightImageView.snp.remakeConstraints({ (make) in
                    make.size.equalTo(CGSize.zero)
                })
                rightImageView.isHidden = true
                largeImageView.snp.remakeConstraints({ (make) in
                    make.size.equalTo(CGSize.zero)
                })
                largeImageView.isHidden = true
            } else {
                if newsTopic!.middle_image!.height != nil {
                    if newsTopic!.video_detail_info?.video_id != nil || newsTopic?.large_image_list.count != 0 {
                        rightImageView.snp.updateConstraints({ (make) in
                            make.size.equalTo(CGSize.zero)
                        })
                        rightImageView.isHidden = true
                        let videoDetailInfo = newsTopic?.video_detail_info
                        var urlString = String()
                        if videoDetailInfo?.video_id != nil {
                            urlString = videoDetailInfo!.detail_video_large_image!.url!
                        }
                        if newsTopic!.large_image_list.count != 0 {
                            urlString = newsTopic!.large_image_list.first!.url!
                        }
                        largeImageView.kf.setImage(with: URL(string: urlString)!)
                    } else {
                        let url = newsTopic?.middle_image!.url
                        rightImageView.kf.setImage(with: URL(string: url!)!)
                        titleLabel.snp.updateConstraints({ (make) in
                            make.right.equalTo(rightImageView.snp.left).offset(-kHomeMargin)
                        })
                    }
                } else {
                    rightImageView.snp.updateConstraints({ (make) in
                        make.size.equalTo(CGSize.zero)
                    })
                    rightImageView.isHidden = true
                    largeImageView.snp.updateConstraints({ (make) in
                        make.size.equalTo(CGSize.zero)
                    })
                    largeImageView.isHidden = true
                }
            }

        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        addSubview(titleLabel)
        
        addSubview(avatarImageView)
        
        addSubview(nameLabel)
        
        addSubview(commentLabel)
        
        addSubview(closeButton)
        
        addSubview(rightImageView)
        
        addSubview(largeImageView)
        
        largeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.size.equalTo(CGSize(width: SCREENW - 30, height: 170))
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.top)
            make.size.equalTo(CGSize(width: 70, height: 108))
            make.right.equalTo(self).offset(-kHomeMargin)
        }
        
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
        
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(avatarImageView)
            make.size.equalTo(CGSize(width: 17, height: 12))
        }
    }
    
    /// 新闻标题
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    /// 中间大图
    fileprivate lazy var largeImageView: UIImageView = {
        let largeImageView = UIImageView()
        return largeImageView
    }()
    
    /// 右边图片
    fileprivate lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        return rightImageView
    }()
    
    /// 用户名头像
    fileprivate lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        return avatarImageView
    }()
    
    /// 用户名
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor.lightGray
        return nameLabel
    }()
    
    /// 评论
    fileprivate lazy var commentLabel: UILabel = {
        let comentLabel = UILabel()
        comentLabel.font = UIFont.systemFont(ofSize: 13)
        comentLabel.textColor = UIColor.lightGray
        return comentLabel
    }()
    
    /// 时间
    fileprivate lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor.lightGray
        return timeLabel
    }()
    
    /// 举报按钮
    fileprivate lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "add_textpage_17x12_"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return closeButton
    }()
    
    /// 举报按钮点击
    func closeBtnClick() {
        closeButtonClosure?(filterWords!)
    }
    /// 举报按钮点击回调
    func closeButtonClick(_ closure:@escaping (_ filterWord: [YMFilterWord])->()) {
        closeButtonClosure = closure
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
