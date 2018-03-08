//
//  GroupIconCell.swift
//  hangge_1462
//
//  Created by hangge on 2016/11/29.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

//组合图标内部小图标
class GroupIconCell:CALayer {
    //使用的图片
    var image: UIImage!
    //裁剪缺口位于圆上的位置（0～360度，0为y轴向下位置，顺时针旋转）
    var degrees: Double!
    //是否裁剪
    var isClip: Bool?
    
    //裁剪角度的一半（30即表示裁剪角度为60度，即圆弧上裁剪部分是1/6（60/360））
    let clipHalfAngle:Double = 30
    
    //初始化
    init(image: UIImage, degrees: Double, isClip: Bool) {
        super.init()
        //参数初始化
        self.degrees = degrees
        self.image = image
        self.isClip = isClip
        //这个记得设置，否则图片在Retina设备上显示不准确，会模糊
        self.contentsScale = UIScreen.main.scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //绘制内容
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)

        let bounds = self.bounds
        //尺寸
        let size = bounds.size
        //半径
        let radius = size.width/2
        //中心点位置
        let center = CGPoint(x:bounds.midX, y:bounds.midY)

        //为方便操作，先变换坐标系
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: CGFloat(radians(degrees: self.degrees)))
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        
        let path = CGMutablePath()
        //判断是非裁剪
        if self.isClip! {
            //绘制大圆弧
            let angle1 = radians(degrees: (90.0-clipHalfAngle))
            let angle2 = radians(degrees: (90.0+clipHalfAngle))
            path.addArc(center: center, radius: radius,
                        startAngle: angle1, endAngle: angle2,
                        clockwise: true, transform: transform)
            
            //绘制小圆弧（形成缺口）
            let angle3 = radians(degrees: (clipHalfAngle))
            let tangent1End = CGPoint(x:radius,
                                      y:radius+(radius*sin(angle1) -
                                        radius*sin(angle3)*tan(angle3)))
            let tangent2End = CGPoint(x:radius+radius*sin(angle3),
                                      y:radius+radius*sin(angle1))
            path.addArc(tangent1End: tangent1End, tangent2End: tangent2End,
                        radius: radius, transform: transform)
        } else {
            //不裁剪的话直接画个圆
            path.addEllipse(in: bounds)
        }
        
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        let bezierPath = UIBezierPath(cgPath: path)
        bezierPath.close()
        //添加路径裁剪
        bezierPath.addClip()
        //图片绘制
        self.image.draw(in: self.bounds)
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        //结束上下文
        UIGraphicsEndImageContext()
        
        //进入新状态
        UIGraphicsPushContext(ctx)
        //绘制裁剪后的图像
        maskedImage.draw(in: self.bounds)
        //回到之前状态
        UIGraphicsPopContext()
    }
}

//将角度转为弧度
func radians(degrees: Double)->CGFloat {
    return CGFloat(degrees/Double(180.0) * M_PI)
}
