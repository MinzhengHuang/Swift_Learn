//
//  YMLoginViewController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/15.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

/// ![](http://obna9emby.bkt.clouddn.com/news/login_spec.png)
class YMLoginViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.borderColor = YMColor(246, g: 68, b: 65, a: 1.0).cgColor
        registerButton.layer.borderWidth = klineWidth
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        
    }
}
