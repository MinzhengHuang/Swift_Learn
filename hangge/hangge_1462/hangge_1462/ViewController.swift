//
//  ViewController.swift
//  hangge_1462
//
//  Created by hangge on 2016/11/29.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //讨论组图标尺寸（长宽一样）
        let viewWH:CGFloat = 140
        //讨论组图标背景色（这里使用灰色，不设置的话则是透明的）
        let viewBgColor = UIColor(red: 0, green:0, blue: 0, alpha: 0.1)
        
        //只由1张图片组成的讨论组图标
        let view1 = GroupIcon(wh: viewWH, images: [UIImage(named:"0")!])
        view1.center = CGPoint(x:85, y:90)
        view1.backgroundColor = viewBgColor
        self.view.addSubview(view1)
        
        //由2张图片组成的讨论组图标
        let view2 = GroupIcon(wh: viewWH, images: [UIImage(named:"0")!,UIImage(named:"1")!])
        view2.center = CGPoint(x:235, y:90)
        view2.backgroundColor = viewBgColor
        self.view.addSubview(view2)
        
        //由3张图片组成的讨论组图标
        let view3 = GroupIcon(wh: viewWH, images: [UIImage(named:"0")!,UIImage(named:"1")!,
                                                   UIImage(named:"2")!])
        view3.center = CGPoint(x:85, y:240)
        view3.backgroundColor = viewBgColor
        self.view.addSubview(view3)
        
        //由4张图片组成的讨论组图标
        let view4 = GroupIcon(wh: viewWH, images: [UIImage(named:"0")!,UIImage(named:"1")!,
                                                   UIImage(named:"2")!,UIImage(named:"3")!])
        view4.center = CGPoint(x:235, y:240)
        view4.backgroundColor = viewBgColor
        self.view.addSubview(view4)

        //由5张图片组成的讨论组图标
        let view5 = GroupIcon(wh: viewWH, images: [UIImage(named:"0")!,UIImage(named:"1")!,
                                                   UIImage(named:"2")!,UIImage(named:"3")!,
                                                   UIImage(named:"4")!])
        view5.center = CGPoint(x:85, y:390)
        view5.backgroundColor = viewBgColor
        self.view.addSubview(view5)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

