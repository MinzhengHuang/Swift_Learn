//
//  YMCareheaderView.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/31.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
import SnapKit
/// ![](http://obna9emby.bkt.clouddn.com/news/care-header.png)
class YMCareheaderView: UIView {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI() {
        // 底部 view
        addSubview(bgView)
        // 红色分割 view
        bgView.addSubview(redView)
        // 标题
        bgView.addSubview(titleLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.bottom.right.equalTo(self)
        }
        
        redView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(15)
            make.size.equalTo(CGSize(width: 5, height: 12))
            make.centerY.equalTo(bgView.centerY)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(redView.snp.right).offset(5)
            make.top.equalTo(redView.snp.top)
            make.bottom.equalTo(redView.snp.bottom)
        }
        
    }
    
    // 底部 view
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    // 红色分割 view
    fileprivate lazy var redView: UIView = {
        let redView = UIView()
        redView.layer.cornerRadius = 2
        redView.layer.masksToBounds = true
        redView.backgroundColor = YMColor(241, g: 94, b: 91, a: 1.0)
        return redView
    }()
    
    // 标题
     lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
