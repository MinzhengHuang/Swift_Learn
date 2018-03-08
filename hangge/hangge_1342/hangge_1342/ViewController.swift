//
//  ViewController.swift
//  hangge_1342
//
//  Created by hangge on 2016/11/21.
//  Copyright © 2016年 hangge. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var catalog = [[String]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化列表数据
        catalog.append(["第一节：Swift 环境搭建",
                        "由于Swift开发环境需要在OS X系统中运行，下面就一起来学习一下。"])
        catalog.append(["第二节：Swift 基本语法。这个标题很长很长很长。",
                        "本节介绍Swift中一些常用的关键字。以及引入、注释等相关操作。"])
        catalog.append(["第三节: Swift 数据类型",
                        "Swift 提供了非常丰富的数据类型，比如：Int、UInt、浮点数、布尔值、字符串、字符等等。"])
        catalog.append(["第四节: Swift 变量",
                        "Swift 每个变量都指定了特定的类型，该类型决定了变量占用内存的大小。"])
        catalog.append(["第五节: Swift 可选(Optionals)类型",
                        "Swift 的可选（Optional）类型，用于处理值缺失的情况。"])
        
        //创建表视图
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //设置estimatedRowHeight属性默认值
        self.tableView.estimatedRowHeight = 44.0;
        //rowHeight属性设置为UITableViewAutomaticDimension
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.catalog.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell",
                                                     for: indexPath) as UITableViewCell
        //获取对应的条目内容
        let entry = catalog[indexPath.row]
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let subtitleLabel = cell.viewWithTag(2) as! UILabel
        titleLabel.text = entry[0]
        subtitleLabel.text = entry[1]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
