//: Playground - noun: a place where people can play

import UIKit

var arr:[Int] = []
for _ in 0..<10{
    arr.append(Int(arc4random())%1000)
}



// 定义比较函数完成自定义排序
func biggerNumberFirst(a:Int , _ b:Int) -> Bool{
    return a > b
}

arr.sorted(by: biggerNumberFirst)


// 使用闭包
arr.sorted(by: {(a: Int , b: Int) -> Bool in
    return a > b
})
