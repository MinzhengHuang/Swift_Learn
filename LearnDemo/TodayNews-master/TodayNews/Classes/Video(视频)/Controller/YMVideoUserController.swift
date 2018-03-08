//
//  YMVideoUserController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/14.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  视频界面 -> 点击 cell 底部的用户昵称 -> 用户详细信息界面
//

import UIKit
/// ![](http://obna9emby.bkt.clouddn.com/news/video-detail-5_spec.png)
class YMVideoUserController: UIViewController {

    var mediaInfo: YMMediaInfo?
    /// 方式 1 使用 scrollView
//    @IBOutlet weak var scrollView: UIScrollView!
    /// 方式 2 使用 webView
    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 方式 1 调用 YMUserHeaderView.swift
//        setupUI()
//        YMNetworkTool.shareNetworkTool.loadVideoMediaEntry(mediaInfo!.media_id!) { [weak self] (mediaEntry) in
//            self!.headerView.media = mediaEntry
//        }
        
        /// 方式 2 使用 webView
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(kHomeMargin)
            make.top.equalTo(view.snp.top).offset(24)
        }
        webView.dataDetectorTypes = .all
        let urlString = BASE_URL + "pgc/m\(mediaInfo!.media_id!)/"
        let request = URLRequest(url: URL(string: urlString)!)
        webView.loadRequest(request)
    }
    
    /// 返回按钮
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "lefterbackicon_titlebar_28x28_"), for: UIControlState())
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return backButton
    }()
    
    /// 返回按钮点击
    func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupUI() {
        
        // 返回按钮点击回调
        headerView.backButtonClosure = {
            self.navigationController?.popViewController(animated: true)
        }
        // 更多按钮点击回调
        headerView.moreButtonClosure = {
            YMHomeShareView.show()
        }
        // 关注按钮点击回调
        headerView.careButtonClosure = { (button) in
            
        }
        // 全部按钮点击回调
        headerView.allButtonClosure = {
            
        }
        // 视频按钮点击回调
        headerView.videoButtonClosure = {
            
        }
    }
    
    
    fileprivate lazy var headerView: YMUserHeaderView = {
        let headerView = YMUserHeaderView.userHeaderView()
        return headerView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMVideoUserController: UIScrollViewDelegate, UIWebViewDelegate {
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        headerView.topView.y = offsetY
        headerView.backButton.centerY = headerView.topView.centerY + kMargin
        if offsetY > -20 {
            headerView.careButton.centerY = headerView.backButton.centerY
            headerView.moreButton.centerY = headerView.backButton.centerY
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
}
