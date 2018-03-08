//
//  YMActivityController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/15.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  活动界面
//

import UIKit

class YMActivityController: UIViewController {
    
    let urlString = BASE_URL + "2/wap/activity/?iid=5124013949"
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_more_titlebar_28x28_"), style: .plain, target: self, action: #selector(activityBBItemClick))
        
        /// 自动对页面进行缩放以适应屏幕
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = .all
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    /// 活动界面更多按钮
    func activityBBItemClick() {
        let alertController = UIAlertController(title: "非Wifi网络流量", message: nil, preferredStyle: .actionSheet)
        let refreshAction = UIAlertAction(title: "刷新", style: .default, handler: { (_) in
            self.webView.reload()
        })
        let copyLinkAction = UIAlertAction(title: "复制链接", style: .default, handler: { (_) in
            // 复制到剪贴板
            let pasteboard = UIPasteboard.general
            pasteboard.string = self.urlString
        })
        let safariAction = UIAlertAction(title: "使用Safari打开", style: .default, handler: { (_) in
            if UIApplication.shared.canOpenURL(URL(string: self.urlString)!) {
                UIApplication.shared.openURL(URL(string: self.urlString)!)
            }
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(refreshAction)
        alertController.addAction(copyLinkAction)
        alertController.addAction(safariAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMActivityController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
