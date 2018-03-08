//
//  ViewController.swift
//  hangge_1406
//
//  Created by hangge on 2016/10/20.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: [String]!
    var tableView: UITableView?
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //随机生成一些初始化数据
        refreshItemData()
        
        //创建表视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(self.tableView!)
        
        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(ViewController.headerRefresh))
//        //隐藏时间
        header.lastUpdatedTimeLabel.isHidden = true
//        //隐藏状态
//        header.stateLabel.isHidden = true
        //修改文字
        header.setTitle("下拉下拉下拉", for: .idle)
        header.setTitle("松开松开松开", for: .pulling)
        header.setTitle("刷新刷新刷新", for: .refreshing)
        
        //修改字体
        header.stateLabel.font = UIFont.systemFont(ofSize: 15)
        header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
        
        //修改文字颜色
        header.stateLabel.textColor = UIColor.red
        header.lastUpdatedTimeLabel.textColor = UIColor.blue
        
//        //下拉过程时的图片集合(根据下拉距离自动改变)
//        var idleImages = [UIImage]()
//        for i in 1...10 {
//            idleImages.append(UIImage(named:"idle\(i)")!)
//        }
//        header.setImages(idleImages, for: .idle) //idle1，idle2，idle3...idle10
//        
//        //下拉到一定距离后，提示松开刷新的图片集合(定时自动改变)
//        var pullingImages = [UIImage]()
//        for i in 1...3 {
//            pullingImages.append(UIImage(named:"pulling\(i)")!)
//        }
//        header.setImages(pullingImages, for: .pulling)
//        
//        //刷新状态下的图片集合(定时自动改变)
//        var refreshingImages = [UIImage]()
//        for i in 1...3 {
//            refreshingImages.append(UIImage(named:"refreshing\(i)")!)
//        }
//        header.setImages(refreshingImages, for: .refreshing)
        
        //        //手动调用刷新效果
        //        header.beginRefreshing()
        
        self.tableView!.mj_header = header
    }
    
    //初始化数据
    func refreshItemData() {
        items = []
        for _ in 0...9 {
            items.append("条目\(Int(arc4random()%100))")
        }
    }
    
    //顶部下拉刷新
    func headerRefresh(){
        print("下拉刷新.")
        sleep(2)
        //重现生成数据
        refreshItemData()
        //重现加载表格数据
        self.tableView!.reloadData()
        //结束刷新
        self.tableView!.mj_header.endRefreshing()
    }
    
    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "SwiftCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                     for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = self.items[indexPath.row]
            return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
