//
//  YMHomeDetailController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/11.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  点击一条新闻 -> 新闻详情(或是一个新的新闻专题列表)
//

import UIKit
import SnapKit
/// ![](http://obna9emby.bkt.clouddn.com/news/home-detail-1.jpg)
/// ![](http://obna9emby.bkt.clouddn.com/news/home-detail-2.jpg)
/// ![](http://obna9emby.bkt.clouddn.com/news/home-detail-3.jpg)
/// ![](http://obna9emby.bkt.clouddn.com/news/home-detail-4.jpg)
class YMHomeDetailController: UIViewController {
    
    var newsTopic: YMNewsTopic?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = YMColor(210, g: 63, b: 66, a: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = YMGlobalColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_more_titlebar_28x28_"), style: .plain, target: self, action: #selector(homeDetailBBItemClick))
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .default
        navigationItem.titleView = searchBar
        searchBar.placeholder = newsTopic?.source!
        
        view.addSubview(webView)
        
        view.addSubview(bottomView)
        
        webView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(45)
        }
        
        let url = URL(string: newsTopic!.url!)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        bottomView.commentCount = newsTopic?.comment_count
    }
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.height = 30
        searchBar.width = SCREENW - 60
        return searchBar
    }()
    
    fileprivate lazy var bottomView: YMHomeDetailBottomView = {
        let bottomView = Bundle.main.loadNibNamed(String(describing: YMHomeDetailBottomView.self), owner: nil, options: nil)?.last as! YMHomeDetailBottomView
        return bottomView
    }()
    
    fileprivate lazy var webView: UIWebView = {
        let webView = UIWebView()
        /// 自动对页面进行缩放以适应屏幕
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        return webView
    }()
    
    /// 更多按钮点击
    func homeDetailBBItemClick() {
        YMHomeShareView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMHomeDetailController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
}
