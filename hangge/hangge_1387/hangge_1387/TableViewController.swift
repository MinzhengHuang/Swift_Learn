//
//  TableViewController.swift
//  hangge_1387
//
//  Created by hangge on 16/10/9.
//  Copyright © 2016年 hangge. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //wifi数据集合
    let wifiArray = ["hangge-wifi-1","hangge-wifi-2","hangge-wifi-3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        //创建一个重用的单元格
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "wifiCell")
        //去除尾部多余的空行
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        //设置分区头部字体颜色和大小
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = UIColor.gray
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium)
    }
    
    //返回分区数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    //返回每个分区中单元格的数量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        if section == 1 {
            return wifiArray.count
        }else{
            return 1
        }
    }

    //设置cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        //只有第二个分区是动态的，其它默认
        if indexPath.section == 1 {
            //用重用的方式获取标识为wifiCell的cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "wifiCell",
                                                     for: indexPath)
            cell.textLabel?.text = wifiArray[indexPath.row]
            return cell
            
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    //因为第二个分区单元格动态添加，会引起cell高度的变化，所以要重新设置
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
       if indexPath.section == 1{
            return 44
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    //当覆盖了静态的cell数据源方法时需要提供一个代理方法。
    //因为数据源对新加进来的cell一无所知，所以要使用这个代理方法
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 1{
            //当执行到日期选择器所在的indexPath就创建一个indexPath然后强插
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }else{
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
