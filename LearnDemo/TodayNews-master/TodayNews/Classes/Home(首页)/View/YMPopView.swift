//
//  YMPopView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/11.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  弹出框
//  这个类写的不好，显示的位置不正确
//

import UIKit
import SnapKit
/// ![](http://obna9emby.bkt.clouddn.com/news/popView_spec.png)
class YMPopView: UIView {

    var filterWords: [YMFilterWord]? {
        didSet {
            let buttonW: CGFloat = (SCREENW - 30 - 26 - 7) * 0.5
            let buttonH: CGFloat = 30
            for index in 0..<filterWords!.count {
                let word = filterWords![index]
                let button = UIButton()
                button.setTitle(word.name, for: UIControlState())
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.setTitleColor(UIColor.black, for: UIControlState())
                button.layer.cornerRadius = 5
                button.layer.masksToBounds = true
                button.layer.borderColor = YMColor(220, g: 220, b: 220, a: 1.0).cgColor
                button.layer.borderWidth = klineWidth
                button.width = buttonW
                button.height = buttonH
                button.x = CGFloat(index % 2) * (buttonW + 7)
                button.y = CGFloat(Int(index / 2)) * (buttonH + 7) + 5
                button.addTarget(self, action: #selector(wordButtonClick(_:)), for: .touchUpInside)
                buttonBGView.addSubview(button)
            }
        }
    }
    
    func wordButtonClick(_ button: UIButton) {
        print("点击了 --- \(button.titleLabel!.text!)")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        addSubview(popArraw)
        addSubview(bgView)
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(interestButton)
        bgView.addSubview(buttonBGView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        popArraw.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-15)
            make.size.equalTo(CGSize(width: 36, height: 8))
            make.bottom.equalTo(bgView.snp.top).offset(1)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(13)
            make.centerY.equalTo(interestButton)
        }
        
        interestButton.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(13)
            make.right.equalTo(bgView).offset(-13)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        buttonBGView.snp.makeConstraints { (make) in
            make.top.equalTo(interestButton.snp.bottom).offset(3)
            make.left.equalTo(bgView.snp.left).offset(13)
            make.right.equalTo(bgView.snp.right).offset(-13)
            make.bottom.equalTo(bgView.snp.bottom)
        }
    }
    
    /// 箭头
    fileprivate lazy var popArraw: UIImageView = {
        let popArraw = UIImageView()
        popArraw.image = UIImage(named: "arrow_up_popup_textpage_36x8_")
        return popArraw
    }()
    
    /// 白色 view
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    /// 可选理由
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "可选理由，精准屏蔽"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    /// 不感兴趣按钮
    fileprivate lazy var interestButton: UIButton = {
        let interestButton = UIButton()
        interestButton.layer.cornerRadius = kHomeMargin
        interestButton.layer.masksToBounds = true
        interestButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        interestButton.setTitle("不感兴趣", for: UIControlState())
        interestButton.setTitleColor(UIColor.white, for: UIControlState())
        interestButton.backgroundColor = YMColor(246, g: 91, b: 93, a: 1.0)
        return interestButton
    }()
    
    /// 放置 6 个按钮的容器 view
    fileprivate lazy var buttonBGView: UIView = {
        let buttonBGView = UIView()
        return buttonBGView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
