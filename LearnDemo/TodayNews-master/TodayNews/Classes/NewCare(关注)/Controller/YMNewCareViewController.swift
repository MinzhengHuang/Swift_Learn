//
//  YMNewCareViewController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/29.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  主控制器
//  3.关心界面
//

import UIKit

let newCareNoLoginCellID = "YMNewCareNoLoginCell"
let newCareTopCellID = "YMNewCareTopCell"
let newCareBottomCellID = "YMNewCareBottomCell"
/// ![](http://obna9emby.bkt.clouddn.com/news/%E5%85%B3%E6%B3%A8-1.jpg)
class YMNewCareViewController: YMBaseViewController {

    var tableView: UITableView?
    
    var topConcerns = [YMConcern]()
    
    var bottomConcerns = [YMConcern]()
    
    var offset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置 UI
        setupUI()
        // 上拉和下拉加载数据
        setupRefresh()
    }
    
    /// 上拉和下拉加载数据
    fileprivate func setupRefresh() {
        YMNetworkTool.shareNetworkTool.loadNewConcernList(tableView!) { (topConcerns, bottomConcerns) in
            self.topConcerns = topConcerns
            self.bottomConcerns = bottomConcerns
            self.tableView!.reloadData()
        }
        
        YMNetworkTool.shareNetworkTool.loadMoreConcernList(tableView!, outOffset: offset) { (inOffset, topConcerns, bottomConcerns) in
            self.topConcerns += topConcerns
            self.bottomConcerns += bottomConcerns
            self.offset = inOffset
            self.tableView!.reloadData()
        }
    }
    
    // 设置 UI
    fileprivate func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_topic_24x24_"), style: .plain, target: self, action: #selector(searchBBItemClick))
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        // 注册没有登录的 cell
        let noLoginNib = UINib(nibName: String(describing: YMNewCareNoLoginCell.self), bundle: nil)
        tableView.register(noLoginNib, forCellReuseIdentifier: newCareNoLoginCellID)
        // 注册顶部的 cell
        let topNib = UINib(nibName: String(describing: YMNewCareTopCell.self), bundle: nil)
        tableView.register(topNib, forCellReuseIdentifier: newCareTopCellID)
        // 注册底部的 cell
        let bottomNib = UINib(nibName: String(describing: YMNewCareBottomCell.self), bundle: nil)
        tableView.register(bottomNib, forCellReuseIdentifier: newCareBottomCellID)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 67
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        tableView.sectionFooterHeight = kMargin
        view.addSubview(tableView)
        self.tableView = tableView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBBItemClick() {
        let searchVC = YMNewCareSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension YMNewCareViewController: UITableViewDelegate, UITableViewDataSource, YMNewCareBottomCellDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? (topConcerns.count == 0 ? 1 : topConcerns.count) : bottomConcerns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // 正在关心
            if topConcerns.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: newCareNoLoginCellID) as! YMNewCareNoLoginCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: newCareTopCellID) as! YMNewCareTopCell
                cell.concern = topConcerns[indexPath.row]
                return cell
            }
        } else { // 可能关心
            let cell = tableView.dequeueReusableCell(withIdentifier: newCareBottomCellID) as! YMNewCareBottomCell
            cell.concern = bottomConcerns[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YMCareheaderView()
        section == 0 ? (headerView.title = "正在关心") : (headerView.title = "可能关心")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if topConcerns.count == 0 {
                return
            }
            let concernDetailVC = YMSelectConcernTableController()
            navigationController?.pushViewController(concernDetailVC, animated: true)
        } else {
            let concernDetailVC = YMSelectConcernTableController()
            navigationController?.pushViewController(concernDetailVC, animated: true)
        }
    }
    
    // MARK: - YMNewCareBottomCellDelegate
    func bottomCell(_ bottomCell: YMNewCareBottomCell, careButton: UIButton) {
        // TODO: - 给 cell 添加动画效果
        
        YMNetworkTool.shareNetworkTool.bottomCellDidClickedCareButton(bottomCell.concern!.concern_id!, tableView: tableView!) { (topConcerns, bottomConcerns) in
            self.topConcerns = topConcerns
            self.bottomConcerns = bottomConcerns
            self.tableView!.reloadData()
        }
    }
    
}
