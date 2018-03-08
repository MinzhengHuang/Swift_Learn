//
//  ViewController.swift
//  hangge_1167
//
//  Created by hangge on 16/5/5.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnClick(_ sender: AnyObject) {
        //从StoryBoard中获取视图控制器
        let logoView  = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "logoView")
        //添加获取到的视图控制器的视图
        self.view.addSubview(logoView.view)
        //添加子视图控制器
        addChildViewController(logoView)
        logoView.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

