//
//  YMHomeTopicController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/6.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

let topicSmallCellID = "YMHomeSmallCell"
let topicMiddleCellID = "YMHomeMiddleCell"
let topicLargeCellID = "YMHomeLargeCell"
let topicNoImageCellID = "YMHomeNoImageCell"

class YMHomeTopicController: UITableViewController {
    
    /// 上一次选中 tabBar 的索引
    var lastSelectedIndex = Int()
    // 下拉刷新的时间
    fileprivate var pullRefreshTime: TimeInterval?
    // 记录点击的顶部标题
    var topTitle: YMHomeTopTitle?
    // 存放新闻主题的数组
    fileprivate var newsTopics = [YMNewsTopic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // 添加上拉刷新和下拉刷新
        setupRefresh()
    }
    
    fileprivate func setupUI() {
        self.definesPresentationContext = true
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 49, 0)
        // 注册 cell
        tableView.register(YMHomeSmallCell.self, forCellReuseIdentifier: topicSmallCellID)
        tableView.register(YMHomeMiddleCell.self, forCellReuseIdentifier: topicMiddleCellID)
        tableView.register(YMHomeLargeCell.self, forCellReuseIdentifier: topicLargeCellID)
        tableView.register(YMHomeNoImageCell.self, forCellReuseIdentifier: topicNoImageCellID)
        // 预设定 cell 的高度为 97
        tableView.estimatedRowHeight = 97
        
        tableView.tableHeaderView = homeSearchBar
        
        // 添加监听，监听 tabbar 的点击
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarSelected), name: NSNotification.Name(rawValue: YMTabBarDidSelectedNotification), object: nil)
    }
    
    func tabBarSelected() {
        //如果是连点 2 次，并且 如果选中的是当前导航控制器，刷新
        if lastSelectedIndex == tabBarController?.selectedIndex {
            tableView.mj_header.beginRefreshing()
        }
        lastSelectedIndex = tabBarController!.selectedIndex
    }
    
    fileprivate lazy var homeSearchBar: YMHomeSearchBar = {
        let homeSearchBar = YMHomeSearchBar()
        homeSearchBar.searchBar.delegate = self
        homeSearchBar.frame = CGRect(x: 0, y: 0, width: SCREENW, height: 44)
        return homeSearchBar
    }()
    
    /// 添加上拉刷新和下拉刷新
    fileprivate func setupRefresh() {
        pullRefreshTime = Date().timeIntervalSince1970
        // 获取首页不同分类的新闻内容
        YMNetworkTool.shareNetworkTool.loadHomeCategoryNewsFeed(topTitle!.category!, tableView: tableView) { [weak self] (nowTime, newsTopics) in
            self!.pullRefreshTime = nowTime
            self!.newsTopics = newsTopics
            self!.tableView.reloadData()
        }
        // 获取更多新闻内容
        YMNetworkTool.shareNetworkTool.loadHomeCategoryMoreNewsFeed(topTitle!.category!, lastRefreshTime: pullRefreshTime!, tableView: tableView) { [weak self] (moreTopics) in
            self?.newsTopics += moreTopics
            self!.tableView.reloadData()
        }
    }
    
    /// 显示弹出屏蔽新闻内容
    fileprivate func showPopView(_ filterWords: [YMFilterWord], point: CGPoint) {
        let popVC = YMPopViewController()
        popVC.filterWords = filterWords
        /// 设置转场动画的代理
        // 默认情况下，modal 会移除以前控制器的 view，替换为当前弹出的控制器
        // 如果自定义转场，就不会移除以前控制器的 view
        popVC.transitioningDelegate = popViewAnimator
        switch filterWords.count {
            case 0:
                popViewAnimator.presentFrame = CGRect.zero
            case 1, 2:
                popViewAnimator.presentFrame = CGRect(x: kHomeMargin, y: point.y, width: SCREENW - 2 * kHomeMargin, height: 104)

            case 3, 4:
                popViewAnimator.presentFrame = CGRect(x: kHomeMargin, y: point.y, width: SCREENW - 2 * kHomeMargin, height: 141)

            case 5, 6:
                popViewAnimator.presentFrame = CGRect(x: kHomeMargin, y: point.y, width: SCREENW - 2 * kHomeMargin, height: 178)
            default:
                popViewAnimator.presentFrame = CGRect.zero
        }
        /// 设置转场的样式
        popVC.modalPresentationStyle = .custom
        present(popVC, animated: true, completion: nil)
    }
    
    // MARK: - 转场动画， 一定要定义一个属性来保存自定义转场对象，否则会报错
    fileprivate lazy var popViewAnimator: YMPopViewAnimator = {
        let popViewAnimator = YMPopViewAnimator()
        return popViewAnimator
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension YMHomeTopicController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 创建搜索内容控制器
        let searchContentVC = YMSearchContentViewController()
//        searchContentVC.delegate = self
        let nav = YMNavigationController(rootViewController: searchContentVC)
        present(nav, animated: false, completion: nil)
        return true
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewNoDataOrNewworkFail(newsTopics.count)
        return newsTopics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsTopic = newsTopics[indexPath.row]
        
        if newsTopic.image_list.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: topicSmallCellID) as! YMHomeSmallCell
            cell.newsTopic = newsTopic
            cell.closeButtonClick({ [weak self] (filterWords) in
                // closeButton 相对于 tableView 的坐标
                let point = self!.view.convert(cell.frame.origin, from: tableView)
                let convertPoint = CGPoint(x: point.x, y: point.y + cell.closeButton.y)
                self!.showPopView(filterWords, point: convertPoint)
            })
            return cell
        } else {
            if newsTopic.middle_image?.height != nil {
                if newsTopic.video_detail_info?.video_id != nil || newsTopic.large_image_list.count != 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: topicLargeCellID) as! YMHomeLargeCell
                    cell.newsTopic = newsTopic
                    cell.closeButtonClick({ [weak self] (filterWords) in
                        // closeButton 相对于 tableView 的坐标
                        let point = self!.view.convert(cell.frame.origin, from: tableView)
                        let convertPoint = CGPoint(x: point.x, y: point.y + cell.closeButton.y)
                        self!.showPopView(filterWords, point: convertPoint)
                    })
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: topicMiddleCellID) as! YMHomeMiddleCell
                    cell.newsTopic = newsTopic
                    cell.closeButtonClick({ [weak self] (filterWords) in
                        // closeButton 相对于 tableView 的坐标
                        let point = self!.view.convert(cell.frame.origin, from: tableView)
                        let convertPoint = CGPoint(x: point.x, y: point.y + cell.closeButton.y)
                        self!.showPopView(filterWords, point: convertPoint)
                    })
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: topicNoImageCellID) as! YMHomeNoImageCell
                cell.newsTopic = newsTopic
                cell.closeButtonClick({ [weak self] (filterWords) in
                    // closeButton 相对于 tableView 的坐标
                    let point = self!.view.convert(cell.frame.origin, from: tableView)
                    let convertPoint = CGPoint(x: point.x, y: point.y + cell.closeButton.y)
                    self!.showPopView(filterWords, point: convertPoint)
                })
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsTopic = newsTopics[indexPath.row]
        return newsTopic.cellHeight
    }
    
    // MARK: - UITableViewDeleagte
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let homeDetailVC = YMHomeDetailController()
        homeDetailVC.newsTopic = newsTopics[indexPath.row]
        navigationController?.pushViewController(homeDetailVC, animated: true)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -20 {
            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
        }
    }
    
}


