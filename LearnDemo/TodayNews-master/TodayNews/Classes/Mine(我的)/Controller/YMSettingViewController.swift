//
//  YMSettingViewController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/30.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
import Kingfisher

let settingCellID = "settingCellID"
/// ![](http://obna9emby.bkt.clouddn.com/news/%E8%AE%BE%E7%BD%AE.png)
class YMSettingViewController: YMBaseViewController {

    var tableView: UITableView?
    
    var settings = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 从沙盒读取缓存数据的大小
        calcuateCacheSizeFromSandBox()
        // 从 plis 加载数据
        loadSettingFromPlist()
        /// 设置 UI
        setupUI()
    }
    
    /// 从沙盒读取缓存数据的大小
    fileprivate func calcuateCacheSizeFromSandBox() {
        let cache = KingfisherManager.shared.cache
        cache.calculateDiskCacheSize { (size) in
            // 转换成 M
            let sizeM = Double(size) / 1024.0 / 1024.0
            let sizeString = String(format: "%.2fM", sizeM)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
        }
        
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = YMGlobalColor()
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        let nib = UINib(nibName: String(describing: YMSettingCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: settingCellID)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0.1 // 默认是0
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        self.tableView = tableView
    }

    // 从 plist 加载数据
    fileprivate func loadSettingFromPlist() {
        let path = Bundle.main.path(forResource: "YMSettingPlist", ofType: "plist")
        let cellPlist = NSArray.init(contentsOfFile: path!)
        for arrayDict in cellPlist! {
            let array = arrayDict as! NSArray
            var sections = [AnyObject]()
            for dict in array {
                let cell = YMSettingModel(dict: dict as! [String: AnyObject])
                sections.append(cell)
            }
            settings.append(sections as AnyObject)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /// 设置字体大小
    fileprivate func setupFontAlertController() {
        let alertController = UIAlertController(title: "设置字体大小", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let smallAction = UIAlertAction(title: "小", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "小"])
        })
        let middleAction = UIAlertAction(title: "中", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "中"])
        })
        let bigAction = UIAlertAction(title: "大", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "大"])
        })
        let largeAction = UIAlertAction(title: "特大", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "特大"])
        })
        alertController.addAction(cancelAction)
        alertController.addAction(smallAction)
        alertController.addAction(middleAction)
        alertController.addAction(bigAction)
        alertController.addAction(largeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // 非 wifi 网络流量
    fileprivate func setupNetworkAlertController() {
        let alertController = UIAlertController(title: "非Wifi网络流量", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let bestFlowAction = UIAlertAction(title: "最佳效果（下载大图）", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "最佳效果（下载大图）"])
        })
        let betterFlowAction = UIAlertAction(title: "较省流量（智能下图）", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "较省流量（智能下图）"])
        })
        let leastFlowAction = UIAlertAction(title: "极省流量（不下载图）", style: .default, handler: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "极省流量（不下载图）"])
        })
        alertController.addAction(cancelAction)
        alertController.addAction(bestFlowAction)
        alertController.addAction(betterFlowAction)
        alertController.addAction(leastFlowAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 清除缓存
    fileprivate func clearCacheAlertController() {
        let alertController = UIAlertController(title: "确定清除所有缓存？问答草稿、离线内容及图片均会被清除", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let cache = KingfisherManager.shared.cache
            cache.clearDiskCache()
            cache.clearMemoryCache()
            cache.cleanExpiredDiskCache()
            let sizeString = "0.00M"
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 头部 view
    fileprivate lazy var headerView: YMSettingHeaderView = {
        let headerView = YMSettingHeaderView.settingHeaderView()
        headerView.delegate = self
        return headerView
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension YMSettingViewController: UITableViewDelegate, UITableViewDataSource, YMSettingHeaderViewDelegate {
    
    // MARK: - YMSettingHeaderViewDelegate
    func settingHeaderView(_ headerView: YMSettingHeaderView, accountManageButton: UIButton) {
        let accountManageVC = YMAccountManageController()
        accountManageVC.title = "账号管理"
        navigationController?.pushViewController(accountManageVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let setting = settings[section] as! [YMSettingModel]
        return setting.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellID) as! YMSettingCell
        let cellArray = settings[indexPath.section] as! [YMSettingModel]
        cell.setting = cellArray[indexPath.row]
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize(_:)), name: NSNotification.Name(rawValue: "fontSize"), object: self)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                NotificationCenter.default.addObserver(self, selector: #selector(changeNeworkMode(_:)), name: NSNotification.Name(rawValue: "networkMode"), object: self)
            } else if indexPath.row == 1 {
                NotificationCenter.default.addObserver(self, selector: #selector(loadCacheSize(_:)), name: NSNotification.Name(rawValue: "cacheSizeM"), object: self)
            }
         } else if indexPath.section == 3 {
            if indexPath.row == 1 {
                cell.selectionStyle = .none
            }
        }
        return cell
    }
    
    func changeFontSize(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = tableView?.cellForRow(at: indexPath) as! YMSettingCell
        cell.rightTitleLabel.text = userInfo["fontSize"] as? String
    }
    
    /// 改变网络模式
    func changeNeworkMode(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = tableView?.cellForRow(at: indexPath) as! YMSettingCell
        cell.rightTitleLabel.text = userInfo["networkMode"] as? String
    }
    
    /// 获取缓存大小
    func loadCacheSize(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let indexPath = IndexPath(row: 1, section: 1)
        let cell = tableView?.cellForRow(at: indexPath) as! YMSettingCell
        cell.rightTitleLabel.text = userInfo["cacheSize"] as? String
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                // 设置字体大小
                setupFontAlertController()
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // 网络流量
                setupNetworkAlertController()
            } else if indexPath.row == 1 {
                // 清除缓存
                clearCacheAlertController()
            }
        }
        
        if indexPath.section == 2 {
            if indexPath.row == 0 { // 推送通知
                let url = URL(string: UIApplicationOpenSettingsURLString)
                UIApplication.shared.openURL(url!)
            } else if indexPath.row == 2 {
                let autoPlayVideoVC = YMAutoPlayVideoController()
                autoPlayVideoVC.title = "自动播放视频"
                navigationController?.pushViewController(autoPlayVideoVC, animated: true)
            }
        }
        
        if indexPath.section == 3 {
            
        }
    }
}
