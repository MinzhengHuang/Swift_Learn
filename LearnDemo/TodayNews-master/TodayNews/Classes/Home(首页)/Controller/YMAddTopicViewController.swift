//
//  YMAddTopicViewController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/3.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

class YMAddTopicViewController: UIViewController {
    /// 我的频道
    var myTopics = [YMHomeTopTitle]()
    /// 推荐频道
    var recommendTopics = [YMHomeTopTitle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        /// 获取推荐标题内容
        YMNetworkTool.shareNetworkTool.loadRecommendTopic { [weak self] (topics) in
            self!.recommendTopics = topics
            
        }
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add_channels_close_20x20_"), style: .plain, target: self, action: #selector(closeBBItemClick))
        // 去除 navigationBar 底部的黑线
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func closeBBItemClick() {
        dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
