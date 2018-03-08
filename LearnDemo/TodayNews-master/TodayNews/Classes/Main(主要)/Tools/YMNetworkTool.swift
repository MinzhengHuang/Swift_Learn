//
//  YMNetworkTool.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/7/30.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import MJRefresh

class YMNetworkTool: NSObject {
    /// 单例
    static let shareNetworkTool = YMNetworkTool()
    
    /// 有多少条文章更新
    func loadArticleRefreshTip(_ finished:@escaping (_ count: Int)->()) {
        let url = BASE_URL + "2/article/v39/refresh_tip/"
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    let data = json["data"].dictionary
                    let count = data!["count"]!.int
                    finished(count!)
                }
        }
        
    }
    
    /// ------------------------ 首 页 -------------------------
    //
    /// 获取首页顶部标题内容(和视频内容使用一个接口)
    func loadHomeTitlesData(_ finished:@escaping (_ topTitles: [YMHomeTopTitle])->()) {
        let url = BASE_URL + "article/category/get_subscribed/v1/?"
        let params = ["device_id": device_id,
                      "aid": 13,
                      "iid": IID] as [String : Any]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    let dataDict = json["data"].dictionary
                    if let data = dataDict!["data"]!.arrayObject {
                        var topics = [YMHomeTopTitle]()
                        for dict in data {
                            let title = YMHomeTopTitle(dict: dict as! [String: AnyObject])
                            topics.append(title)
                        }
                        finished(topics)
                    }
                }
        }
    }
    
    /// 获取首页不同分类的新闻内容(和视频内容使用一个接口)
    func loadHomeCategoryNewsFeed(_ category: String, tableView: UITableView, finished:@escaping (_ nowTime: TimeInterval,_ newsTopics: [YMNewsTopic])->()) {
        let url = BASE_URL + "api/news/feed/v39/?"
        let params = ["device_id": device_id,
                      "category": category,
                      "iid": IID]
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            let nowTime = Date().timeIntervalSince1970
            Alamofire
                .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    tableView.mj_header.endRefreshing()
                    guard response.result.isSuccess else {
                        SVProgressHUD.showError(withStatus: "加载失败...")
                        return
                    }
                    if let value = response.result.value {
                        let json = JSON(value)
                        let datas = json["data"].array
                        var topics = [YMNewsTopic]()
                        for data in datas! {
                            let content = data["content"].stringValue
                            let contentData: Data = content.data(using: String.Encoding.utf8)!
                            do {
                                let dict = try JSONSerialization.jsonObject(with: contentData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                print(dict)
                                let topic = YMNewsTopic(dict: dict as! [String : AnyObject])
                                topics.append(topic)
                            } catch {
                                SVProgressHUD.showError(withStatus: "获取数据失败!")
                            }
                            
                        }
                        finished(nowTime, topics)
                    }
            }
        })
        tableView.mj_header.isAutomaticallyChangeAlpha = true //根据拖拽比例自动切换透
        tableView.mj_header.beginRefreshing()
    }
    
    /// 获取首页不同分类的新闻内容
    func loadHomeCategoryMoreNewsFeed(_ category: String, lastRefreshTime: TimeInterval, tableView: UITableView, finished:@escaping (_ moreTopics: [YMNewsTopic])->()) {
        let url = BASE_URL + "api/news/feed/v39/?"
        let params = ["device_id": device_id,
                      "category": category,
                      "iid": IID,
                      "last_refresh_sub_entrance_interval": lastRefreshTime] as [String : Any]
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            Alamofire
                .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    tableView.mj_footer.endRefreshing()
                    guard response.result.isSuccess else {
                        SVProgressHUD.showError(withStatus: "加载失败...")
                        return
                    }
                    if let value = response.result.value {
                        let json = JSON(value)
                        let datas = json["data"].array
                        var topics = [YMNewsTopic]()
                        for data in datas! {
                            let content = data["content"].stringValue
                            let contentData: Data = content.data(using: String.Encoding.utf8)!
                            do {
                                let dict = try JSONSerialization.jsonObject(with: contentData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                let topic = YMNewsTopic(dict: dict as! [String : AnyObject])
                                topics.append(topic)
                            } catch {
                                SVProgressHUD.showError(withStatus: "获取数据失败!")
                            }
                        }
                        finished(topics)
                    }
            }
        })
    }
    
    /// 首页 -> 『+』点击，添加标题，获取推荐标题内容
    func loadRecommendTopic(_ finished:@escaping (_ recommendTopics: [YMHomeTopTitle]) -> ()) {
        let url = "https://lf.snssdk.com/article/category/get_extra/v1/?"
        let params = ["device_id": device_id,
                      "aid": 13,
                      "iid": IID] as [String : Any]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    if let data = json["data"].arrayObject {
                        var topics = [YMHomeTopTitle]()
                        for dict in data {
                            let title = YMHomeTopTitle(dict: dict as! [String: AnyObject])
                            topics.append(title)
                        }
                        finished(topics)
                    }
                }
        }
    }
    
    /// -------------------------- 视 频 --------------------------
    //
    /// 获取视频顶部标题内容
    func loadVideoTitlesData(_ finished:@escaping (_ topTitles: [YMVideoTopTitle])->()) {
        // version_code 表示今日头条的版本号，经过测试 >= 5.6 版本新增了『火山直播』
        // os_version 表示 iOS 的系统版本，经测试 >= 8.0 版本新增了『火山直播』
        let url = BASE_URL + "video_api/get_category/v1/?"
        let params = ["device_id": device_id,
                      "version_code": "5.7.1",
                      "iid": IID,
                      "device_platform": "iphone",
                      "os_version": "9.3.2"]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    if let data = json["data"].arrayObject {
                        var titles = [YMVideoTopTitle]()
                        for dict in data {
                            let title = YMVideoTopTitle(dict: dict as! [String: AnyObject])
                            titles.append(title)
                        }
                        finished(titles)
                    }
                }
        }
    }
    
    /// 获取发布用户的信息
    func loadVideoMediaEntry(_ entry_id: Int, finished:@escaping (_ mediaEntry: YMMediaEntry) -> ()) {
        let url = BASE_URL + "entry/profile/v1/?"
        let params = ["entry_id": entry_id]
        Alamofire
            .request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    if let data = json["data"].dictionaryObject {
                        let media = YMMediaEntry(dict: data as [String : AnyObject])
                        finished(media)
                    }
                }
        }
    }
    
    /// -------------------------- 关 心 --------------------------
    //
    /// 获取新的 关心数据列表
    func loadNewConcernList(_ tableView: UITableView, finished:@escaping (_ topConcerns: [YMConcern], _ bottomConcerns: [YMConcern]) -> ()) {
        let url = BASE_URL + "concern/v1/concern/list/"
        let params = ["iid": IID,
                      "count": 20,
                      "offset": 0,
                      "type": "manage"] as [String : Any]
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            Alamofire
                .request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    tableView.mj_header.endRefreshing()
                    guard response.result.isSuccess else {
                        SVProgressHUD.showError(withStatus: "加载失败...")
                        return
                    }
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let concern_list = json["concern_list"].arrayObject {
                            var topConcerns = [YMConcern]()
                            var bottomConcerns = [YMConcern]()
                            for dict in concern_list {
                                let concern = YMConcern(dict: dict as! [String: AnyObject])
                                (concern.concern_time != 0) ? topConcerns.append(concern) : bottomConcerns.append(concern)
                            }
                            finished(topConcerns, bottomConcerns)
                        }
                    }
            }
        })
        tableView.mj_header.isAutomaticallyChangeAlpha = true //根据拖拽比例自动切换透明度
        tableView.mj_header.beginRefreshing()
    }
    
    /// 获取新的 关心数据列表，不显示上拉刷新
    func loadNewConcernListHiddenPullRefresh(_ finished:@escaping (_ topConcerns: [YMConcern], _ bottomConcerns: [YMConcern]) -> ()) {
        let url = BASE_URL + "concern/v1/concern/list/"
        let params = ["iid": IID,
                      "count": 20,
                      "offset": 0,
                      "type": "manage"] as [String : Any]
        Alamofire
            .request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    if let concern_list = json["concern_list"].arrayObject {
                        var topConcerns = [YMConcern]()
                        var bottomConcerns = [YMConcern]()
                        for dict in concern_list {
                            let concern = YMConcern(dict: dict as! [String: AnyObject])
                            (concern.concern_time != 0) ? topConcerns.append(concern) : bottomConcerns.append(concern)
                        }
                        finished(topConcerns, bottomConcerns)
                    }
                }
        }
    }
    
    /// 获取更多 关心数据列表
    func loadMoreConcernList(_ tableView: UITableView, outOffset: Int, finished:@escaping (_ inOffset: Int, _ topConcerns: [YMConcern], _ bottomConcerns: [YMConcern]) -> ()) {
        let url = BASE_URL + "concern/v1/concern/list/"
        let params = ["iid": IID,
                      "count": 20,
                      "offset": outOffset,
                      "type": "recommend"] as [String : Any]
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            Alamofire
                .request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    tableView.mj_footer.endRefreshing()
                    guard response.result.isSuccess else {
                        SVProgressHUD.showError(withStatus: "加载失败...")
                        return
                    }
                    if let value = response.result.value {
                        let json = JSON(value)
                        let inOffset = json["offset"].int!
                        if let concern_list = json["concern_list"].arrayObject {
                            var topConcerns = [YMConcern]()
                            var bottomConcerns = [YMConcern]()
                            for dict in concern_list {
                                let concern = YMConcern(dict: dict as! [String: AnyObject])
                                (concern.concern_time != 0) ? topConcerns.append(concern) : bottomConcerns.append(concern)
                            }
                            finished(inOffset, topConcerns, bottomConcerns)
                        }
                    }
            }
        })
    }
    
    /// 关心界面 -> 底部 cell 的『关心』按钮 点击
    func bottomCellDidClickedCareButton(_ concernID: String, tableView: UITableView, finish:@escaping (_ topConcerns: [YMConcern], _ bottomConcerns: [YMConcern])->()) {
        let url = BASE_URL + "concern/v1/commit/care/"
        let params = ["iid": IID, "concern_id": concernID]
        Alamofire
            .request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
        .responseJSON { (response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showError(withStatus: "加载失败...")
                return
            }
            YMNetworkTool.shareNetworkTool.loadNewConcernListHiddenPullRefresh({ (topConcerns, bottomConcerns) in
                finish(topConcerns, bottomConcerns)
            })
        }
        
    }
    
    /// 关心界面 -> 搜索关心类别和内容
    func loadSearchResult(_ keyword: String, finished:@escaping (_ keywords: [YMKeyword]) -> ()) {
        let url = BASE_URL + "2/article/search_sug/?keyword=\(keyword)"
        Alamofire
            .request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    SVProgressHUD.showError(withStatus: "加载失败...")
                    return
                }
                if let value = response.result.value {
                    let json = JSON(value)
                    if let datas = json["data"].arrayObject {
                        var keywords = [YMKeyword]()
                        for data in datas {
                            let keyword = YMKeyword(dict: data  as! [String: AnyObject])
                            keywords.append(keyword)
                        }
                        finished(keywords)
                    }
                }
        }
        
        
    }
    
}
