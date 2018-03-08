//
//  YMHomeViewController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/29.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
/// ![首页-1](http://obna9emby.bkt.clouddn.com/news/%E9%A6%96%E9%A1%B5-1_spec.png)
let homeTopicCellID = "YMHomeTopicCell"

class YMHomeViewController: UIViewController {
    // 当前选中的 titleLabel 的 上一个 titleLabel
    var oldIndex: Int = 0
    /// 首页顶部标题
    var homeTitles = [YMHomeTopTitle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 有多少条文章更新
        showRefreshTipView()
        // 处理标题的回调
        homeTitleViewCallback()
    }
    
    fileprivate func setupUI() {
        view!.backgroundColor = YMGlobalColor()
        //不要自动调整inset
        automaticallyAdjustsScrollViewInsets = false
        // 设置导航栏属性
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = YMColor(210, g: 63, b: 66, a: 1.0)
        // 设置 titleView
        navigationItem.titleView = titleView
        // 添加滚动视图
        view.addSubview(scrollView)
    }
    
    /// 每次刷新显示的提示标题
    fileprivate lazy var tipView: YMTipView = {
        let tipView = YMTipView()
        tipView.frame = CGRect(x: 0, y: 44, width: SCREENW, height: 35)
        // 加载 navBar 上面，不会随着 tableView 一起滚动
        self.navigationController?.navigationBar.insertSubview(tipView, at: 0)
        return tipView
    }()
    
    /// 滚动视图
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = UIScreen.main.bounds
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    /// 顶部标题
    fileprivate lazy var titleView: YMScrollTitleView = {
        let titleView = YMScrollTitleView()
        return titleView
    }()
    
    /// 有多少条文章更新
    fileprivate func showRefreshTipView() {
        YMNetworkTool.shareNetworkTool.loadArticleRefreshTip { [weak self] (count) in
            self!.tipView.tipLabel.text = (count == 0) ? "暂无更新，请休息一会儿" : "今日头条推荐引擎有\(count)条刷新"
            UIView.animate(withDuration: kAnimationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self!.tipView.tipLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: { (_) in
                    self!.tipView.tipLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                        self!.tipView.isHidden = true
                    })
            })
        }
    }
    
    /// 处理标题的回调
    fileprivate func  homeTitleViewCallback() {
        // 返回标题的数量
        titleView.titleArrayClosure { [weak self] (titleArray) in
            self!.homeTitles = titleArray
            // 归档标题数据
            self!.archiveTitles(titleArray)
            for topTitle in titleArray {
                let topicVC = YMHomeTopicController()
                topicVC.topTitle = topTitle
                self!.addChildViewController(topicVC)
            }
            self!.scrollViewDidEndScrollingAnimation(self!.scrollView)
            self!.scrollView.contentSize = CGSize(width: SCREENW * CGFloat(titleArray.count), height: SCREENH)
        }
        
        // 添加按钮点击
        titleView.addButtonClickClosure { [weak self] in
            let addTopicVC = YMAddTopicViewController()
            addTopicVC.myTopics = self!.homeTitles
            let nav = YMNavigationController(rootViewController: addTopicVC)
            self!.present(nav, animated: false, completion: nil)
        }
        
        // 点击了哪一个 titleLabel，然后 scrolleView 进行相应的偏移
        titleView.didSelectTitleLableClosure { [weak self] (titleLabel) in
            var offset = self!.scrollView.contentOffset
            offset.x = CGFloat(titleLabel.tag) * self!.scrollView.width
            self!.scrollView.setContentOffset(offset, animated: true)
        }
    }
    
    /// 归档标题数据
    fileprivate func archiveTitles(_ titles: [YMHomeTopTitle]) {
        let path: NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as NSString
        let filePath = path.appendingPathComponent("top_titles.archive")
        // 归档
        NSKeyedArchiver.archiveRootObject(titles, toFile: filePath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        /// 在这个控制器里写这句话，好像没用，因为这个控制器在运行过程中不会被销毁
        NotificationCenter.default.removeObserver(self)
    }
}

extension YMHomeViewController: UIScrollViewDelegate {
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 取出子控制器
        let vc = childViewControllers[index]
        vc.view.x = scrollView.contentOffset.x
        vc.view.y = 0
        vc.view.height = scrollView.height
        scrollView.addSubview(vc.view)
    }
    
    // scrollView 刚开始滑动时
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 记录刚开始拖拽是的 index
        self.oldIndex = index
    }
    
    // scrollView 结束滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
        // 当前索引
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        // 与刚开始拖拽时的 index 进行比较
        // 检查是否需要改变 label 的位置
        titleView.adjustTitleOffSetToCurrentIndex(index, oldIndex: self.oldIndex)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}


