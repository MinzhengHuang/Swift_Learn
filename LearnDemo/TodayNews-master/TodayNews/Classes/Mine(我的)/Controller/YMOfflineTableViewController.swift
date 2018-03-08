//
//  YMOfflineTableViewController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/15.
//  Copyright © 2016年 hrscy. All rights reserved.
//
//  我的 -> 离线 -> 离线下载
//

import UIKit
let offlineCellID = "YMOfflineCell"

/// ![](http://obna9emby.bkt.clouddn.com/news/offline-download_spec.png)
class YMOfflineTableViewController: UITableViewController {
    
    var titles = [YMHomeTopTitle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 反归档
        unarchiveTitles()
        // 下载按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下载", style: .plain, target: self, action: #selector(offlineBBItemClick))
        let nib = UINib(nibName: String(describing: YMOfflineCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: offlineCellID)
        tableView.tableFooterView = UIView()
    }
    
    /// 反归档
    fileprivate func unarchiveTitles() {
        let path: NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as NSString
        let filePath = path.appendingPathComponent("top_titles.archive")
        titles = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! Array
    }
    
    func offlineBBItemClick() {
        print(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension YMOfflineTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topTitle = titles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: offlineCellID) as! YMOfflineCell
        cell.selectionStyle = .none
        cell.topTitle = topTitle
        cell.selectedImageView.image = UIImage(named: (topTitle.isSelected ? "air_download_option_press_20x20_" : "air_download_option_20x20_"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topTitle = titles[indexPath.row]
        topTitle.isSelected = !topTitle.isSelected
        let cell = tableView.dequeueReusableCell(withIdentifier: offlineCellID) as! YMOfflineCell
        cell.selectedImageView.image = UIImage(named: (topTitle.isSelected ? "air_download_option_press_20x20_" : "air_download_option_20x20_"))
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        titles.remove(at: indexPath.row)
        titles.insert(topTitle, at: indexPath.row)
        // 重新归档数据
        archiveTitles(titles)
    }
    
    /// 归档标题数据
    fileprivate func archiveTitles(_ titles: [YMHomeTopTitle]) {
        let path: NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as NSString
        let filePath = path.appendingPathComponent("top_titles.archive")
        // 归档
        NSKeyedArchiver.archiveRootObject(titles, toFile: filePath)
    }
}
