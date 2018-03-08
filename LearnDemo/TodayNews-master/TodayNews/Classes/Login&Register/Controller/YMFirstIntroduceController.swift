//
//  YMFirstIntroduceController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/9.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

/// ![](http://obna9emby.bkt.clouddn.com/news/%E5%90%AF%E5%8A%A8_spec.png)
class YMFirstIntroduceController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mobileButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func wechatButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func QQButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func weiboButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func enterButtonClick(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.rootViewController = YMTabBarController()
    }
}
