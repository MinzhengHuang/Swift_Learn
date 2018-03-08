//
//  YMMineViewController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/29.
//  Copyright © 2016年 hrscy. All rights reserved.

///

import UIKit

let mineCellID = "YMMineCell"
/// ![](http://obna9emby.bkt.clouddn.com/news/%E6%88%91%E7%9A%84-%E6%9C%AA%E7%99%BB%E5%BD%95_spec.png)
/// ![](http://obna9emby.bkt.clouddn.com/news/%E6%88%91%E7%9A%84.png)
class YMMineViewController: UITableViewController {
    
    var cells = [AnyObject]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 从 plist 加载数据
        loadCellFromPlist()
        // 设置 UI
        setupUI()
    }
    
    // 从 plist 加载数据
    fileprivate func loadCellFromPlist() {
        let path = Bundle.main.path(forResource: "YMMineCellPlist", ofType: "plist")
        let cellPlist = NSArray.init(contentsOfFile: path!)
        for arrayDict in cellPlist! {
            let array = arrayDict as! NSArray
            var sections = [AnyObject]()
            for dict in array {
                let cell = YMMineCellModel(dict: dict as! [String: AnyObject])
                sections.append(cell)
            }
            cells.append(sections as AnyObject)
        }
    }

    fileprivate func setupUI() {
        view.backgroundColor = YMGlobalColor()
        let nib = UINib(nibName: String(describing: YMMineCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: mineCellID)
        let footerView = UIView()
        footerView.height = kMargin
        tableView.tableFooterView = footerView
        tableView.rowHeight = kMineCellH
        tableView.separatorStyle = .none
        UserDefaults.standard.bool(forKey: isLogin) ? (tableView.tableHeaderView = headerView) : (tableView.tableHeaderView = noLoginHeaderView)
        headerView.headerViewClosure = { (iconButton) in
            print(iconButton)
        }
        
        headerView.bottomView.collectionButtonClosure = { (collectionButton) in
            let collectionVC = YMCollectionViewController()
            collectionVC.title = "收藏"
            self.navigationController?.pushViewController(collectionVC, animated: true)
        }
        
        headerView.bottomView.nightButtonClosure = { (nightButton) in
            print(nightButton)
        }

        headerView.bottomView.settingButtonClosure = { (settingButton) in
            let settingVC = YMSettingViewController()
            settingVC.title = "设置"
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
        
        noLoginHeaderView.bottomView.collectionButtonClosure = headerView.bottomView.collectionButtonClosure
        
        noLoginHeaderView.bottomView.nightButtonClosure = headerView.bottomView.nightButtonClosure
        
        noLoginHeaderView.bottomView.settingButtonClosure = headerView.bottomView.settingButtonClosure
        
    }
    
    /// 懒加载，创建 未登录 headerView
    fileprivate lazy var noLoginHeaderView: YMMineNoLoginHeaderView = {
        let noLoginHeaderView = YMMineNoLoginHeaderView.noLoginHeaderView()
        noLoginHeaderView.delegate = self
        return noLoginHeaderView
    }()
    
    /// 懒加载，创建 headerView
    fileprivate lazy var headerView: YMMineHeaderView = {
        let headerView = YMMineHeaderView.headerView()
        return headerView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMMineViewController: YMMineNoLoginHeaderViewDelegate {
    
    // MARK: - YMMineNoLoginHeaderViewDelegate
    func noLoginHeaderView(_ headerView: YMMineNoLoginHeaderView, mobileLoginButtonClick: UIButton) {
        print(#function)
    }
    
    func noLoginHeaderView(_ headerView: YMMineNoLoginHeaderView, wechatLoginButtonClick: UIButton) {
        print(#function)
    }
    
    func noLoginHeaderView(_ headerView: YMMineNoLoginHeaderView, qqLoginButtonClick: UIButton) {
        print(#function)
    }
    
    func noLoginHeaderView(_ headerView: YMMineNoLoginHeaderView, weiboLoginButtonClick: UIButton) {
        print(#function)
    }
    
    func noLoginHeaderView(_ headerView: YMMineNoLoginHeaderView, moreLoginButtonClick: UIButton) {
        let loginVC = YMLoginViewController()
        loginVC.title = "登录"
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellAyyay = cells[section] as! [YMMineCellModel]
        return cellAyyay.count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mineCellID) as! YMMineCell
        let cellArray = cells[indexPath.section] as! [YMMineCellModel]
        cell.cellModel = cellArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let loginVC = YMLoginViewController()
                loginVC.title = "登录"
                navigationController?.pushViewController(loginVC, animated: true)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 1 {
                let offlineVC = YMOfflineTableViewController()
                offlineVC.title = "离线下载"
                navigationController?.pushViewController(offlineVC, animated: true)
            } else if indexPath.row == 2{
                let activityVC = YMActivityController()
                activityVC.title = "活动"
                navigationController?.pushViewController(activityVC, animated: true)
            } else if indexPath.row == 4 {
                let loginVC = YMLoginViewController()
                loginVC.title = "登录"
                navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
    
    // MARK: - UIScrollViewDelagate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            if UserDefaults.standard.bool(forKey: isLogin) {
                var tempFrame = headerView.bgImageView.frame
                tempFrame.origin.y = offsetY
                tempFrame.size.height = kYMMineHeaderImageHeight - offsetY
                headerView.bgImageView.frame = tempFrame
            headerView.bgImageView.snp.updateConstraints({ (make) in
                make.height.equalTo(tempFrame.size.height)
            })
            } else {
                var tempFrame = noLoginHeaderView.bgImageView.frame
                tempFrame.origin.y = offsetY
                tempFrame.size.height = kYMMineHeaderImageHeight - offsetY
                noLoginHeaderView.bgImageView.frame = tempFrame
            }
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
