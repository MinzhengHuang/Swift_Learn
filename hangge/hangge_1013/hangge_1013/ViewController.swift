//
//  ViewController.swift
//  hangge_1013
//
//  Created by hangge on 16/1/8.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //签名预览
    @IBOutlet weak var imageView: UIImageView!
    
    //签名区域视图
    var drawView:DrawSignatureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //签名区域位置尺寸
        var drawViewFrame = self.view.bounds
        drawViewFrame.size.height = 200
        //添加签名区域
        drawView = DrawSignatureView(frame: drawViewFrame)
        self.view.addSubview(drawView)
             
    }

    //预览签名
    @IBAction func previewSignature(_ sender: AnyObject) {
        let signatureImage = self.drawView.getSignature()
        imageView.image = signatureImage
    }
    
    //保存签名
    @IBAction func savaSignature(_ sender: AnyObject) {
        let signatureImage = self.drawView.getSignature()
        UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
        self.drawView.clearSignature()
    }
    
    //清除签名
    @IBAction func clearSignature(_ sender: AnyObject) {
        self.drawView.clearSignature()
        self.imageView.image = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

