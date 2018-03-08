//
//  ImageDownloader.swift
//  T2
//
//  Created by hangge on 15/9/28.
//  Copyright © 2015年 hangge. All rights reserved.
//

import UIKit

//图片下载操作任务
class ImageDownloader: Operation {
    //电影条目对象
    let movieRecord: MovieRecord
    
    init(movieRecord: MovieRecord) {
        self.movieRecord = movieRecord
    }
    
    //在子类中重载Operation的main方法来执行实际的任务。
    override func main() {
        //在开始执行前检查撤消状态。任务在试图执行繁重的工作前应该检查它是否已经被撤消。
        if self.isCancelled {
            return
        }
        //sleep(1) //这个只是为了便于测试观察
        
        //下载图片。
        let imageData = try? Data(contentsOf: self.movieRecord.url as URL)
        
        //再一次检查撤销状态。
        if self.isCancelled {
            return
        }
        
        //如果有数据，创建一个图片对象并加入记录，然后更改状态。如果没有数据，将记录标记为失败并设置失败图片。
        if imageData != nil {
            self.movieRecord.image = UIImage(data:imageData!)
            self.movieRecord.state = .downloaded
        } else {
            self.movieRecord.state = .failed
            self.movieRecord.image = UIImage(named: "failed")
        }
    }
}
