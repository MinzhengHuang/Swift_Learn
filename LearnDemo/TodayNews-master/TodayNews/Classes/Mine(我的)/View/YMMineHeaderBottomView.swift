//
//  YMMineHeaderBottomView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/30.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  我的界面 -> 头部 view -> 底部白色 view(包含三个按钮)
//

import UIKit
import Kingfisher

class YMMineHeaderBottomView: UIView {
    
    /// 收藏按钮回调
    var collectionButtonClosure: ((_ collectionButton: UIButton) -> ())?
    /// 夜间按钮回调
    var nightButtonClosure: ((_ nightButton: UIButton) -> ())?
    /// 设置按钮回调
    var settingButtonClosure: ((_ settingButton: UIButton) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        // 设置三个按钮
        setupUI()
    }
    
    /// 设置三个按钮
    fileprivate func setupUI() {
        // 添加收藏按钮
        addSubview(collectionButton)
        // 添加夜间按钮
        addSubview(nightButton)
        // 添加设置按钮
        addSubview(settingButton)
        
        collectionButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.bottom.equalTo(self)
            make.left.equalTo(self).offset(50)
            make.right.lessThanOrEqualTo(nightButton).offset(-kMargin)
        }
        
        nightButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.bottom.equalTo(self)
            make.centerX.equalTo(self.centerX)
        }
        
        settingButton.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.bottom.equalTo(self)
            make.right.equalTo(self).offset(-50)
            make.right.greaterThanOrEqualTo(nightButton).offset(kMargin)
        }
    }
    
    /// 懒加载，创建收藏按钮
    fileprivate lazy var collectionButton: YMVerticalButton = {
        let collectionButton = YMVerticalButton()
        collectionButton.setTitle("收 藏", for: UIControlState())
        collectionButton.setTitleColor(UIColor.black, for: UIControlState())
        collectionButton.addTarget(self, action: #selector(collectionBtnClick(_:)), for: .touchUpInside)
        collectionButton.setImage(UIImage(named: "favoriteicon_profile_24x24_"), for: UIControlState())
        
        collectionButton.setImage(UIImage(named: "favoriteicon_profile_press_24x24_"), for: .highlighted)
        collectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return collectionButton
    }()
    
    /// 懒加载，创建夜间按钮
    fileprivate lazy var nightButton: YMVerticalButton = {
        let nightButton = YMVerticalButton()
        nightButton.setTitle("夜 间", for: UIControlState())
        nightButton.setTitleColor(UIColor.black, for: UIControlState())
        nightButton.addTarget(self, action: #selector(nightBtnClick(_:)), for: .touchUpInside)
        nightButton.setImage(UIImage(named: "nighticon_profile_24x24_"), for: UIControlState())
        
        nightButton.setImage(UIImage(named: "nighticon_profile_press_24x24_"), for: .highlighted)
        nightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return nightButton
    }()
    
    /// 懒加载，创建设置按钮
    fileprivate lazy var settingButton: YMVerticalButton = {
        let settingButton = YMVerticalButton()
        settingButton.setTitle("设 置", for: UIControlState())
        settingButton.setTitleColor(UIColor.black, for: UIControlState())
        settingButton.setImage(UIImage(named: "setupicon_profile_24x24_"), for: UIControlState())
        
        settingButton.setImage(UIImage(named: "setupicon_profile_press_24x24_"), for: .highlighted)
        settingButton.addTarget(self, action: #selector(settingBtnClick(_:)), for: .touchUpInside)
        settingButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return settingButton
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionBtnClick(_ button: YMVerticalButton) {
        collectionButtonClosure?(button)
    }
    
    func nightBtnClick(_ button: YMVerticalButton) {
        nightButtonClosure?(button)
    }
    
    func settingBtnClick(_ button: YMVerticalButton) {
        settingButtonClosure?(button)
    }
}
