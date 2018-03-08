//
//  ImageFiltration.swift
//  T2
//
//  Created by hangge on 15/9/28.
//  Copyright © 2015年 hangge. All rights reserved.
//

import UIKit
import CoreImage

//滤镜处理任务
class ImageFiltration: Operation {
    //电影条目对象
    let movieRecord: MovieRecord
    
    init(movieRecord: MovieRecord) {
        self.movieRecord = movieRecord
    }
    
    //在子类中重载Operation的main方法来执行实际的任务。
    override func main () {
        if self.isCancelled {
            return
        }
        
        if self.movieRecord.state != .downloaded {
            return
        }
        
        if let filteredImage = self.applySepiaFilter(self.movieRecord.image!) {
            self.movieRecord.image = filteredImage
            self.movieRecord.state = .filtered
        }
    }
    
    //给图片添加棕褐色滤镜
    func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:UIImagePNGRepresentation(image)!)
        
        if self.isCancelled {
            return nil
        }
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(0.8, forKey: "inputIntensity")
        let outputImage = filter?.outputImage
        
        if self.isCancelled {
            return nil
        }
        
        let outImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let returnImage = UIImage(cgImage: outImage!)
        return returnImage
    }
}
