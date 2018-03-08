//: Playground - noun: a place where people can play

import UIKit

let str = "Hello, swift"

// 大小写转换
str.uppercased()
str.lowercased()
str.capitalized


// 使用String的方法
str.contains("Hello")
str.hasPrefix("Hello")
str.hasSuffix("swift")


// String的缺点
let s = "one third is \(1.0/3.0)"
print(s)

// 注意：现在Swift中的String和OC中的NSString之间的界限越来越小，如使用format初始化一个String，在Swift2中已经可以了。具体代码如下：
let ss = String(format: "one third is %.2f", 1.0/3.0)


// as String
let s2 = NSString(format: "one third is %.2f😀", 1.0/3.0) as String
print(s2)


// NSString
var s3:NSString = "one third is 0.33😀"
s3.substring(from: 4)
s3.substring(to: 3)
s3.substring(with: NSMakeRange(4, 5))


// String和NSString的不同
let s4 = "😀😀😀"
let s5:NSString = "😀😀😀"
s4.characters.count
s5.length


let s6 = "   --- Hello -----    " as NSString
s6.trimmingCharacters(in: NSCharacterSet(charactersIn: " -") as CharacterSet)

let range = s6.range(of: "ll")
range.location
range.length

s4.replacingOccurrences(of: "He", with: "Apo")



var hh = "hmzxhdahsfjh"
var rangez = hh.range(of: "z")
var ranges = hh.range(of: "s")

hh.substring(to: (rangez?.upperBound)!)
hh.substring(to: (rangez?.lowerBound)!)

hh.substring(from: (rangez?.upperBound)!)
hh.substring(from: (rangez?.lowerBound)!)

var hh2 = "hmz zmh"
var rangezz = hh2.range(of: " ")

hh2.substring(to: (rangezz?.lowerBound)!)
hh2.substring(from: (rangezz?.upperBound)!)





