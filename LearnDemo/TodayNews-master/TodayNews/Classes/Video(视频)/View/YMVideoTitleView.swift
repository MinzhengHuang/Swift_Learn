//
//  YMTitleView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/1.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//
//  主页顶部标题
//  与首页的标题类似

import UIKit
import SnapKit

protocol YMVideoTitleViewDelegate: NSObjectProtocol {
    /// 点击了标题
    func videoTitle(_ videoTitle: YMVideoTitleView, didSelectVideoTitleLable titleLabel: YMTitleLabel)
    func videoTitle(_ videoTitle: YMVideoTitleView, didClickSearchButton searchButton: UIButton)
}

/// ![](http://obna9emby.bkt.clouddn.com/news/video-title.png)
class YMVideoTitleView: UIView {
    weak var delegate: YMVideoTitleViewDelegate?
    
    /// 顶部标题数组
    var titles = [YMVideoTopTitle]()
    /// 存放标题 label 数组
    var labels = [YMTitleLabel]()
    /// 存放 label 的宽度
    fileprivate var labelWidths = [CGFloat]()
    /// 顶部导航栏右边加号按钮点击
    /// 向外界传递 titles 数组
    var videoTitlesClosure: ((_ titleArray: [YMVideoTopTitle])->())?
    /// 记录当前选中的下标
    fileprivate var currentIndex = 0
    /// 记录上一个下标
    fileprivate var oldIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// 获取数据
        YMNetworkTool.shareNetworkTool.loadVideoTitlesData({ [weak self] (topTitles) in
            // 添加推荐标题
            let dict = ["category": "video", "name": "推荐"]
            let recommend = YMVideoTopTitle(dict: dict as [String : AnyObject])
            self!.titles.append(recommend)
            self!.titles += topTitles
            self!.setupUI()
        })
    }
    
    fileprivate func setupUI() {
        // 添加滚动视图
        addSubview(scrollView)
        // 添加搜索按钮
        addSubview(titleSearchButton)

        scrollView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(titleSearchButton.snp.left)
        }
        
        titleSearchButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(self)
            make.width.equalTo(30)
        }
        
        /// 添加 label
        setupVideoTitlesLable()
        /// 设置 label 的位置
        setupVideoLabelsPosition()
        
        videoTitlesClosure?(titles)
    }
    
    /// 暴露给外界，向外界传递 topic 数组
    func videoTitleArrayClosure(_ closure: @escaping (_ titleArray: [YMVideoTopTitle])->()) {
        videoTitlesClosure = closure
    }
    
    /// 顶部搜索按钮
    fileprivate lazy var titleSearchButton: UIButton = {
        let titleSearchButton = UIButton()
        titleSearchButton.addTarget(self, action: #selector(titleSearchButtonClick(_:)), for: .touchUpInside)
        titleSearchButton.setImage(UIImage(named: "search_topic_24x24_"), for: UIControlState())
        return titleSearchButton
    }()
    
    /// 设置滚动视图
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YMVideoTitleView {
    
    /// 搜索按钮点击
    func titleSearchButtonClick(_ button: UIButton) {
        delegate?.videoTitle(self, didClickSearchButton: button)
    }
    
    /// 添加 label
    fileprivate func setupVideoTitlesLable() {
        for (index, topic) in titles.enumerated() {
            let label = YMTitleLabel()
            label.text = topic.name
            label.tag = index
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelOnClick(_:)))
            label.addGestureRecognizer(tap)
            label.font = UIFont.systemFont(ofSize: 17)
            label.sizeToFit()
            label.width += kMargin
            labels.append(label)
            labelWidths.append(label.width)
            scrollView.addSubview(label)
        }
        let currentLabel = labels[currentIndex]
        currentLabel.textColor = YMColor(232, g: 84, b: 85, a: 1.0)
        currentLabel.currentScale = 1.1
    }
    
    /// 设置 label 的位置
    fileprivate func setupVideoLabelsPosition() {
        var titleX: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleH = self.height
        
        for (index, label) in labels.enumerated() {
            titleW = labelWidths[index]
            titleX = kMargin
            if index != 0 {
                let lastLabel = labels[index - 1]
                titleX = lastLabel.frame.maxX + kMargin
            }
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        }
        /// 设置 contentSize
        if let lastLabel = labels.last {
            scrollView.contentSize = CGSize(width: lastLabel.frame.maxX, height: 0)
        }
    }
    
    /// 标题点击的方法
    func titleLabelOnClick(_ tap: UITapGestureRecognizer) {
        guard let  currentLabel = tap.view as? YMTitleLabel else {
            return
        }
        
        oldIndex = currentIndex
        currentIndex = currentLabel.tag
        let oldLabel = labels[oldIndex]
        oldLabel.textColor = UIColor.black
        oldLabel.currentScale = 1.0
        currentLabel.textColor = YMColor(232, g: 84, b: 85, a: 1.0)
        currentLabel.currentScale = 1.1
        
        // 改变 label 的位置
        adjustVideoTitleOffSetToCurrentIndex(currentIndex, oldIndex: oldIndex)
        // 获取点击的 titleLabel
        delegate?.videoTitle(self, didSelectVideoTitleLable: currentLabel)
    }
    
    /// 当点击标题的时候，检查是否需要改变 label 的位置
    func adjustVideoTitleOffSetToCurrentIndex(_ currentIndex: Int, oldIndex: Int) {
        guard oldIndex != currentIndex else {
            return
        }
        // 重新设置 label 的状态
        let currentLabel = labels[currentIndex]
        let oldLabel = labels[oldIndex]
        currentLabel.currentScale = 1.1
        currentLabel.textColor = YMColor(232, g: 84, b: 85, a: 1.0)
        oldLabel.textColor = UIColor.black
        oldLabel.currentScale = 1.0
        // 当前偏移量
        var offsetX = currentLabel.centerX - SCREENW * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        // 最大偏移量
        var maxOffsetX = scrollView.contentSize.width - (SCREENW - titleSearchButton.width)
        
        if maxOffsetX < 0 {
            maxOffsetX = 0
        }
        
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    /// 重写 frame
    override var frame: CGRect {
        didSet {
            let newFrame = CGRect(x: 0, y: 0, width: SCREENW, height: 44)
            super.frame = newFrame
        }
    }
}
