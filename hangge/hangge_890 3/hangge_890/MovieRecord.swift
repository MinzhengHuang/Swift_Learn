import UIKit

// 这个枚举包含所有电影图片的状态
enum MovieRecordState {
    case new, downloaded, filtered, failed
}

// 电影条目类
class MovieRecord {
    let name:String
    let url:URL
    var state = MovieRecordState.new
    //默认初始图片
    var image = UIImage(named: "placeholder")
    
    init(name:String, url:URL) {
        self.name = name
        self.url = url
    }
}
