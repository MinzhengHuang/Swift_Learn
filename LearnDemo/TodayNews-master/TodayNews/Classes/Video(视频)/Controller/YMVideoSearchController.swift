//
//  YMVideoSearchController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/1.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  搜索界面
//

import UIKit

class YMVideoSearchController: UIViewController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = YMGlobalColor()
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelBBItemClick))
        navigationItem.rightBarButtonItem?.tintColor = YMColor(37, g: 142, b: 240, a: 1.0)
    }
    
    func cancelBBItemClick() {
        navigationController?.popViewController(animated: false)
    }
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "请输入关键字"
        return searchBar
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMVideoSearchController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
}
