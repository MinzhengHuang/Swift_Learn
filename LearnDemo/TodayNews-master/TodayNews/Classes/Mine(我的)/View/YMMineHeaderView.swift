//
//  YMMineHeaderView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/30.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  我的界面 -> 头部
//

import UIKit
import SnapKit

class YMMineHeaderView: UIView {
    
    /// 头像按钮点击的回调
    var headerViewClosure: ((_ iconButton: UIButton) -> ())?
    
    class func headerView() -> YMMineHeaderView {
        let frame = CGRect(x: 0, y: 0, width: SCREENW, height: 260)
        return YMMineHeaderView(frame: frame)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置 UI
        setupUI()
    
    }
    
    /// 设置 UI
    fileprivate func setupUI() {
        // 添加背景图片
        addSubview(bgImageView)
        // 添加头像按钮
        addSubview(headPhotoButton)
        // 添加底部 view
        addSubview(bottomView)
        
        // 设置约束
        bgImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(-2 * kMargin)
            make.height.equalTo(kYMMineHeaderImageHeight)
        }
        
        headPhotoButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(0)
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.top.equalTo(bgImageView.snp.top).offset(64)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(bgImageView.snp.bottom)
        }
    }
    
    /// 懒加载，创建背景图片
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "hrscy")
        return bgImageView
    }()
    
    /// 懒加载，创建头像按钮
    lazy var headPhotoButton: YMMineHeaderIconButton = {
        let headPhotoButton = YMMineHeaderIconButton()
        headPhotoButton.addTarget(self, action: #selector(headPhotoBtnClick(_:)), for: .touchUpInside)
        headPhotoButton.setTitle("hrscy", for: UIControlState())
        headPhotoButton.setImage(UIImage(named: "hrscy"), for: UIControlState())
        return headPhotoButton
    }()
    
    /// 懒加载，创建底部白色 view
    lazy var bottomView: YMMineHeaderBottomView = {
        let bottomView = YMMineHeaderBottomView()
        return bottomView
    }()
    
    /// 头像按钮点击
    func headPhotoBtnClick(_ button: YMMineHeaderIconButton) {
        headerViewClosure?(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
