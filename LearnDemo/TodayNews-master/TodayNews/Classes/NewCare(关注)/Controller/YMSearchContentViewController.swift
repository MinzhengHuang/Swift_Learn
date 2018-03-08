//
//  YMSearchContentViewController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/2.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  显示搜索结果
//

import UIKit

protocol YMSearchContentViewControllerDelegate: NSObjectProtocol {
    func cancelButtonClickedPopViewcontroller()
}

let searchContentCellID = "YMsearchCell"

/// ![](http://obna9emby.bkt.clouddn.com/news/search-care.png)
class YMSearchContentViewController: YMBaseViewController {

    var keywords = [YMKeyword]()
    
    weak var tableView: UITableView?
    
    weak var delegate: YMSearchContentViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // 设置 UI
    fileprivate func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelBBItemClick))
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem?.tintColor = YMColor(37, g: 142, b: 240, a: 1.0)
        let tableView = UITableView(frame: view.bounds)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = kMargin
        let nib = UINib(nibName: String(describing: YMsearchCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: searchContentCellID)
        view.addSubview(tableView)
        self.tableView = tableView
    }

    fileprivate lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.height = 40
//        searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchbar_location_2x44_"), forState: .Normal)
        searchBar.placeholder = "请输入关键字"
        return searchBar
    }()
    
    func cancelBBItemClick() {
        searchBar.resignFirstResponder()
        weak var weakSelf = self
        dismiss(animated: false) {
            weakSelf!.delegate?.cancelButtonClickedPopViewcontroller()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension YMSearchContentViewController: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchContentCellID) as! YMsearchCell
        cell.searchText = searchBar.text
        cell.keyword = keywords[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text
        YMNetworkTool.shareNetworkTool.loadSearchResult(searchText!) { (keywords) in
            self.keywords = keywords
            self.tableView?.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        YMNetworkTool.shareNetworkTool.loadSearchResult(searchText!) { (keywords) in
            self.keywords = keywords
            self.tableView?.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
}
