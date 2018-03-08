//
//  YMHomeShareView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/12.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  分享界面
//

import UIKit
/// ![](http://obna9emby.bkt.clouddn.com/news/home-share.png)
class YMHomeShareView: UIView {

    var shares = [YMHomeShare]()
    
    class func show() {
        let homeShareView = YMHomeShareView()
        homeShareView.frame = UIScreen.main.bounds
        homeShareView.backgroundColor = YMColor(0, g: 0, b: 0, a: 0.3)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(homeShareView)
        UIView.animate(withDuration: kAnimationDuration, animations: { 
            homeShareView.bgView.frame = CGRect(x: 0, y: SCREENH - 290, width: SCREENW, height: 290)
            }, completion: { (_) in
                homeShareView.addButton(homeShareView.topScrollView)
                /// 延时操作
                let delayTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                    homeShareView.addButton(homeShareView.bottomScrollView)
                })
        }) 
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let path = Bundle.main.path(forResource: "YMSharePlist", ofType: ".plist")
        let shareArray = NSArray(contentsOfFile: path!)
        for item in shareArray! {
            let share = YMHomeShare(dict: item as! [String : AnyObject])
            shares.append(share)
        }
        
        setupUI()
    }
    
    func setupUI() {
        bgView.frame = CGRect(x: 0, y: SCREENH, width: SCREENW, height: 290)
        addSubview(bgView)
        topScrollView.frame = CGRect(x: 0, y: 0, width: SCREENW, height: 126)
        bgView.addSubview(topScrollView)
        lineView.frame = CGRect(x: 22, y: topScrollView.frame.maxY, width: SCREENW - 44, height: 1)
        bgView.addSubview(lineView)
        bottomScrollView.frame = CGRect(x: 0, y: lineView.frame.maxY, width: SCREENW, height: 166)
        bgView.addSubview(bottomScrollView)
        
        cancelButton.frame = CGRect(x: 0, y: bgView.height - 48, width: SCREENW, height: 48)
        bgView.addSubview(cancelButton)
    }
    
    // 上部的滚动视图
    fileprivate lazy var topScrollView: UIScrollView = {
        let topScrollView = UIScrollView()
        topScrollView.showsHorizontalScrollIndicator = false
        return topScrollView
    }()
    
    // 下部的滚动视图
    fileprivate lazy var bottomScrollView: UIScrollView = {
        let bottomScrollView = UIScrollView()
        bottomScrollView.showsHorizontalScrollIndicator = false
        return bottomScrollView
    }()
    
    /// 取消按钮
    fileprivate lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: UIControlState())
        cancelButton.layer.borderColor = YMColor(220, g: 220, b: 220, a: 1.0).cgColor
        cancelButton.layer.borderWidth = klineWidth
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cancelButton.setTitleColor(UIColor.black, for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        return cancelButton
    }()
    
    // 白色背景
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = YMColor(240, g: 240, b: 240, a: 1.0)
        return bgView
    }()
    
    /// 分割线
    fileprivate lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = YMColor(220, g: 220, b: 220, a: 1.0)
        return lineView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension YMHomeShareView {
    
    /// 点击了某个分享按钮
    func shareButtonClick(_ button: YMShareVerticalButton) {
        print("点击了---- \(button.titleLabel!.text!)")
    }
    
    /// 创建分享按钮
    func addButton(_ scrollView: UIScrollView) {
        let buttonW: CGFloat = 80
        let buttonH: CGFloat = 80
        let buttonY: CGFloat = scrollView.frame.maxY
        
        for index in 0..<shares.count {
            let share = shares[index]
            let button = YMShareVerticalButton()
            button.tag = index
            button.setImage(UIImage(named: "\(share.icon!)"), for: UIControlState())
            button.setTitle(share.title, for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.addTarget(self, action: #selector(shareButtonClick(_:)), for: .touchUpInside)
            let buttonX = CGFloat(index) * buttonW + 2 * kMargin
            
            button.x = buttonX
            button.width = buttonW
            button.height = buttonH
            scrollView.addSubview(button)
            button.y = buttonY
            UIView.animate(withDuration: kAnimationDuration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    button.y = 23
                }, completion: nil)
            if index == shares.count - 1 {
                scrollView.contentSize = CGSize(width: button.frame.maxX + 2 * kMargin, height: topScrollView.height)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: kAnimationDuration, animations: { 
            self.bgView.frame = CGRect(x: 0, y: SCREENH, width: SCREENW, height: 290)
            }, completion: { (_) in
                self.removeFromSuperview()
        }) 
    }
    
    /// 取消按钮点击
    func cancelButtonClick() {
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.bgView.frame = CGRect(x: 0, y: SCREENH, width: SCREENW, height: 290)
        }, completion: { (_) in
            self.removeFromSuperview()
        }) 
    }
}
