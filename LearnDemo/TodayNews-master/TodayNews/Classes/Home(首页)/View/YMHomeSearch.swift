//
//  YMHomeSearch.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/10.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  首页顶部搜索栏
//

import UIKit
import SnapKit

class YMHomeSearchBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = YMGlobalColor()
        addSubview(searchBar)
        
        searchBar.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: SCREENW - 30, height: 30))
            make.center.equalTo(self)
        }
    }
    
    lazy var searchBar: YMSearchBar = {
        let searchBar = YMSearchBar()
        searchBar.placeholder = "搜索"
        return searchBar
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YMSearchBar: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.cornerRadius = kCornerRadius
        layer.masksToBounds = true
        let searchIcon = UIImageView()
        font = UIFont.systemFont(ofSize: 15)
        searchIcon.image = UIImage(named: "search_discover_16x16_")
        searchIcon.width = 16
        searchIcon.height = 16
        leftView = searchIcon
        leftViewMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
