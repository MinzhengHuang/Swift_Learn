//
//  YMVideoTopicController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/5.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  视频显示 cell 的控制器
//

import UIKit
import SnapKit
import AVFoundation

let videoTopicCellID = "YMVideTopicCell"
/// ![](http://obna9emby.bkt.clouddn.com/news/topicVC.png)
class YMVideoTopicController: UITableViewController {
    
    var lastSelectCell: YMVideoTopicCell?
    
    var playView: YMPlayerView?
    
    // 下拉刷新的时间
    fileprivate var pullRefreshTime: TimeInterval?
    // 记录点击的顶部标题
    var videoTitle: YMVideoTopTitle?
    // 存放新闻主题的数组
    fileprivate var newsTopics = [YMNewsTopic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRefresh()
    }
    
    fileprivate func setupUI() {
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
        let nib = UINib(nibName: String(describing: YMVideoTopicCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: videoTopicCellID)
        tableView.rowHeight = 270
        tableView.separatorStyle = .none
    }
    
    /// 添加上拉刷新和下拉刷新
    fileprivate func setupRefresh() {
        pullRefreshTime = Date().timeIntervalSince1970
        // 获取首页不同分类的新闻内容
        YMNetworkTool.shareNetworkTool.loadHomeCategoryNewsFeed(videoTitle!.category!, tableView: tableView) { [weak self] (nowTime, newsTopics) in
            self!.pullRefreshTime = nowTime
            self!.newsTopics = newsTopics
            self!.tableView.reloadData()
        }
        // 获取更多新闻内容
        YMNetworkTool.shareNetworkTool.loadHomeCategoryMoreNewsFeed(videoTitle!.category!, lastRefreshTime: pullRefreshTime!, tableView: tableView) { [weak self] (moreTopics) in
            self?.newsTopics += moreTopics
            self!.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension YMVideoTopicController: YMVideoTopicCellDelegate {
    
    // MARK: - YMVideoTopicCellDelegate
    /// 昵称按钮点击
    func videoTopicCell(_ videoTopicCell: YMVideoTopicCell, nameButtonClick nameButton: UIButton) {
        let userVC = YMVideoUserController()
        userVC.mediaInfo = videoTopicCell.videoTopic?.media_info
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    /// 背景按钮点击
    func videoTopicCell(_ videoTopicCell: YMVideoTopicCell, bgImageButtonClick bgImageButton: UIButton) {
        if lastSelectCell != nil {
            // 上次选中的 cell
            lastSelectCell?.playButton.isHidden = false
            lastSelectCell?.playButton.isSelected = false
            lastSelectCell?.titleLabel.isHidden = false
            lastSelectCell?.timeLabel.isHidden = false
            lastSelectCell?.loadingImageView.isHidden = true
            playView?.player.currentItem?.cancelPendingSeeks()
            playView?.player.currentItem?.asset.cancelLoading()
            playView!.removeFromSuperview()
        }
        
        // 当前选中的 cell
        videoTopicCell.titleLabel.isHidden = true
        videoTopicCell.playButton.isHidden = true
        videoTopicCell.timeLabel.isHidden = true
        
        let playerView = YMPlayerView()
        bgImageButton.addSubview(playerView)
        playView = playerView
        
        playerView.snp.makeConstraints { (make) in
            make.edges.equalTo(bgImageButton)
        }
        
        // 添加视频链接
        // 说明：今日头条的返回的视频是一个网址，但是获取不到视频的真实地址，所以用了一个视频来代替返回数据，
        // 另外，还请大家不要吐槽这个视频，毕竟现在的视频全是『宝宝』的视频。。(˶‾᷄ ⁻̫ ‾᷅˵)
        // 嗯嗯，一切为了技术~ ୧( ⁼̴̶̤̀ω⁼̴̶̤́ )૭
        let item = AVPlayerItem(url: URL(string: "http://wvideo.spriteapp.cn/video/2016/0817/57b3bc156c6ef_wpd.mp4")!)
        
        playerView.playerItem = item
        
        // 覆盖按钮点击
        playerView.coverButtonClosure = { (coverButton) in
            videoTopicCell.titleLabel.isHidden = !coverButton.isSelected
        }
        
        addAnimation(videoTopicCell.loadingImageView)
        lastSelectCell = videoTopicCell
    }
    
    /// 添加动画
    func addAnimation(_ loading: UIImageView) {
        loading.isHidden = false
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 1
        // 绕 z 轴旋转 180°
        animation.toValue = M_PI * 2.0
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // 如果是在 OC 里，应这样写 animation.repeatCount = HUGE_VALF;
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        loading.layer.add(animation, forKey: animation.keyPath)
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            loading.layer.removeAllAnimations()
            loading.isHidden = true
            self.playView!.playButton.isSelected = true
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTopics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: videoTopicCellID) as! YMVideoTopicCell
        cell.videoTopic = newsTopics[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        /// 更多按钮点击回调
        cell.moreButtonClosure = {
            YMHomeShareView.show()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoDetailVC = YMVideoDetailController()
        videoDetailVC.videoTopic = newsTopics[indexPath.row]
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }
}
