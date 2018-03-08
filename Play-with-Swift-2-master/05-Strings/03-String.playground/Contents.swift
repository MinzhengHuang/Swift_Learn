//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Swift"

// 不可以使用[]获取
//str[0]
//str.characters[0]

// startIndex
let startIndex = str.startIndex
startIndex
str[startIndex]

// advancedBy 访问其开始后一个字符
//str[startIndex.advancedBy(5)]
//在Swift3.0 advancedBy使用以下代替：
str.index(startIndex, offsetBy: 5)
str[str.index(startIndex, offsetBy: 5)]


// predecessor 和 succesor
//访问其结束前一个字符
//str[spaceIndex.predecessor()]
//在Swift3.0 predecessor使用以下代替：
str[str.index(before: str.endIndex)]
////访问其开始后一个字符
//str[spaceIndex.successor()]
str[str.index(after: str.startIndex)]



str.append("!!!")
str.insert("?", at: str.endIndex)
str.remove( at: str.index(before: str.endIndex) )
str
str.removeSubrange(str.index(startIndex, offsetBy: 2)..<str.endIndex )




