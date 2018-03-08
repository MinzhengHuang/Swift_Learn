//
//  GroupIcon.swift
//  hangge_1462
//
//  Created by hangge on 2016/11/29.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

//组合图标
class GroupIcon:UIView {
    //整个组合图标的长宽尺寸（两个相等）
    var wh:CGFloat!
    //组合图标内部使用的图片
    var images:[UIImage]!
    
    //初始化
    init(wh:CGFloat, images:[UIImage]) {
        //初始化
        super.init(frame:CGRect(x:0, y:0, width:wh, height:wh))
        self.wh = wh
        self.images = images
        
        //背景默认透明
        self.backgroundColor = UIColor.clear
        
        //如果传入的图片数组为空，就不继续创建内部元素了
        if (self.images.count <= 0) {
            return
        }
        
        //根据数量的不同，调用不同的创建方法
        switch images.count{
        case 1:
            self.createCells1()
        case 2:
            self.createCells2()
        case 3:
            self.createCells3()
        case 4:
            self.createCells4()
        case 5:
            //如果有5个或5个以上的图片的话，都只使用前5个图片
            fallthrough
        default:
            self.createCells5()
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //创建内部图标元素（只有一个图标的情况）
    func createCells1(){
        //内部小图标的直径
        let cellD = self.wh!
        //内部小图标的半径
        let cellR = cellD / 2
        //内部每个小图标的尺寸
        let cellSize = CGSize(width:cellD, height:cellD)
        
        //第1个小图标
        let layer0 = GroupIconCell(image:images[0], degrees:0, isClip:false)
        let center0 = CGPoint(x:cellR, y:cellR)
        layer0.frame = getRect(center: center0, size: cellSize)
        self.layer.addSublayer(layer0)
        layer0.setNeedsDisplay()
    }
    
    //创建内部图标元素（有2个图标的情况）
    func createCells2(){
        //内部小图标的直径
        let cellD = (self.wh+self.wh-CGFloat(sqrtf(2))*self.wh)
        //内部小图标的半径
        let cellR = cellD / 2
        //内部每个小图标的尺寸
        let cellSize = CGSize(width:cellD, height:cellD)
        
        //第1个小图标
        let layer0 = GroupIconCell(image:images[0], degrees:0, isClip:false)
        let center0 = CGPoint(x:cellR, y:cellR)
        layer0.frame = getRect(center: center0, size: cellSize)
        self.layer.addSublayer(layer0)
        layer0.setNeedsDisplay()
        
        //第2个小图标
        let layer1 = GroupIconCell(image:images[1], degrees:180 - 45, isClip:true)
        let center1 = CGPoint(x:cellR+CGFloat(sqrtf(2))*cellD/2,
                              y:cellR+CGFloat(sqrtf(2))*cellD/2)
        layer1.frame = getRect(center: center1, size: cellSize)
        self.layer.addSublayer(layer1)
        layer1.setNeedsDisplay()
    }
    
    //创建内部图标元素（有3个图标的情况）
    func createCells3(){
        //内部小图标的直径
        let cellD = self.wh/2
        //内部每个小图标的尺寸
        let cellSize = CGSize(width:cellD, height:cellD)
        
        //第1个小图标
        let layer0 = GroupIconCell(image:images[0], degrees:30, isClip:true)
        let center0 = CGPoint(x:cellD, y:cellD/2)
        layer0.frame = getRect(center: center0, size: cellSize)
        self.layer.addSublayer(layer0)
        layer0.setNeedsDisplay()
        
        //第2个小图标
        let layer1 = GroupIconCell(image:images[1], degrees:270, isClip:true)
        let center1 = CGPoint(x:center0.x-cellD*sin(radians(degrees: 30)),
                              y:cellD/2+cellD*cos(radians(degrees: 30)))
        layer1.frame = getRect(center: center1, size: cellSize)
        self.layer.addSublayer(layer1)
        layer1.setNeedsDisplay()
        
        //第2个小图标
        let layer2 = GroupIconCell(image:images[2], degrees:180 - 30, isClip:true)
        let center2 = CGPoint(x:center1.x+cellD, y:center1.y)
        layer2.frame = getRect(center: center2, size: cellSize)
        self.layer.addSublayer(layer2)
        layer2.setNeedsDisplay()
    }
    
    //创建内部图标元素（有4个图标的情况）
    func createCells4(){
        //内部小图标的直径
        let cellD = self.wh/2
        //内部小图标的半径
        let cellR = cellD / 2
        //内部每个小图标的尺寸
        let cellSize = CGSize(width:cellD, height:cellD)
        
        //第1个小图标
        let layer0 = GroupIconCell(image:images[0], degrees:0, isClip:true)
        let center0 = CGPoint(x:cellR, y:cellR)
        layer0.frame = getRect(center: center0, size: cellSize)
        self.layer.addSublayer(layer0)
        layer0.setNeedsDisplay()
        
        //第2个小图标
        let layer1 = GroupIconCell(image:images[1], degrees:270, isClip:true)
        let center1 = CGPoint(x:center0.x, y:center0.y+cellD)
        layer1.frame = getRect(center: center1, size: cellSize)
        self.layer.addSublayer(layer1)
        layer1.setNeedsDisplay()
        
        //第3个小图标
        let layer2 = GroupIconCell(image:images[2], degrees:180, isClip:true)
        let center2 = CGPoint(x:center1.x+cellD, y:center1.y)
        layer2.frame = getRect(center:center2, size: cellSize)
        self.layer.addSublayer(layer2)
        layer2.setNeedsDisplay()
        
        //第4个小图标
        let layer3 = GroupIconCell(image:images[3], degrees:90, isClip:true)
        let center3 = CGPoint(x:center2.x, y:center2.y-cellD)
        layer3.frame = getRect(center:center3, size: cellSize)
        self.layer.addSublayer(layer3)
        layer3.setNeedsDisplay()
    }
    
    //创建内部图标元素（有5个图标的情况）
    func createCells5(){
        //内部小图标的半径
        let cellR = self.wh/2/(2*sin(radians(degrees: 54))+1)
        //内部小图标的直径
        let cellD = cellR*2
        //内部每个小图标的尺寸
        let cellSize = CGSize(width:cellD, height:cellD)
        
        //第1个小图标
        let layer0 = GroupIconCell(image:images[0], degrees:54, isClip:true)
        let center0 = CGPoint(x:self.wh/2, y:cellR)
        layer0.frame = getRect(center:center0, size: cellSize)
        self.layer.addSublayer(layer0)
        layer0.setNeedsDisplay()
        
        //第2个小图标
        let layer1 = GroupIconCell(image:images[1], degrees:270 + 72, isClip:true)
        let center1 = CGPoint(x:center0.x-cellD*sin(radians(degrees: 54)),
                              y:center0.y+cellD*cos(radians(degrees: 54)))
        layer1.frame = getRect(center:center1, size: cellSize)
        self.layer.addSublayer(layer1)
        layer1.setNeedsDisplay()
        
        //第3个小图标
        let layer2 = GroupIconCell(image:images[2], degrees:270, isClip:true)
        let center2 = CGPoint(x:center1.x+cellD*cos(radians(degrees: 72)),
                              y:center1.y+cellD*sin(radians(degrees: 72)))
        layer2.frame = getRect(center:center2, size: cellSize)
        self.layer.addSublayer(layer2)
        layer2.setNeedsDisplay()
        
        //第4个小图标
        let layer3 = GroupIconCell(image:images[3], degrees:180 + 18, isClip:true)
        let center3 = CGPoint(x:center2.x+cellD, y:center2.y)
        layer3.frame = getRect(center:center3, size: cellSize)
        self.layer.addSublayer(layer3)
        layer3.setNeedsDisplay()
        
        //第5个小图标
        let layer4 = GroupIconCell(image:images[4], degrees:90 + 36, isClip:true)
        let center4 = CGPoint(x:center3.x+cellD*cos(radians(degrees: 72)),
                              y:center3.y-cellD*sin(radians(degrees: 72)))
        layer4.frame = getRect(center:center4, size: cellSize)
        self.layer.addSublayer(layer4)
        layer4.setNeedsDisplay()
    }
    
    //通过中心点坐标和Size尺寸，返回对应的CGRect
    func getRect(center:CGPoint, size:CGSize) -> CGRect {
        return CGRect(x:center.x - size.width / 2, y:center.y - size.height / 2,
                      width:size.width, height:size.height)
    }
}
