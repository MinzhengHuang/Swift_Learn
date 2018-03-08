//: Playground - noun: a place where people can play

import UIKit
import XCPlayground


let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
view.backgroundColor = UIColor.orange

let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
button.center = view.center

// Swift 2.2中，Playground中的UI控件支持交互了。简单为button在highlighted的状态下设置另外一个颜色，就可以点击看到效果了:)
button.setTitleColor(UIColor.white, for: .normal)
button.setTitleColor(UIColor.blue, for: .highlighted)

button.setTitle("Click Me :)", for: .normal)

view.addSubview(button)

XCPlaygroundPage.currentPage.liveView = view


