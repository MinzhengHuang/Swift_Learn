//
//  ViewController.swift
//  hangge_1169
//
//  Created by hangge on 2016/12/24.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class ViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //选择器
    var pickerView:UIPickerView!
    
    //所以地址数据集合
    var addressArray = [[String: AnyObject]]()
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化数据
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
        
        //创建选择器
        pickerView=UIPickerView()
        //将dataSource设置成自己
        pickerView.dataSource=self
        //将delegate设置成自己
        pickerView.delegate=self
        self.view.addSubview(pickerView)
        
        //建立一个按钮，触摸按钮时获得选择框被选择的索引
        let button = UIButton(frame:CGRect(x:0, y:0, width:100, height:30))
        button.center = self.view.center
        button.backgroundColor = UIColor.blue
        button.setTitle("获取信息",for:.normal)
        button.addTarget(self, action:#selector(ViewController.getPickerViewValue),
                         for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    
    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //设置选择框的行数，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.addressArray.count
        } else if component == 1 {
            let province = self.addressArray[provinceIndex]
            return province["cities"]!.count
        } else {
            let province = self.addressArray[provinceIndex]
            if let city = province["cities"]![cityIndex] as? [String: AnyObject] {
                return city["areas"]!.count
            } else {
                return 0
            }
        }
    }
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return self.addressArray[row]["state"] as? String
            }else if component == 1 {
                let province = self.addressArray[provinceIndex]
                let city = province["cities"]![row] as! [String: AnyObject]
                return city["city"] as? String
            }else {
                let province = self.addressArray[provinceIndex]
                let city = province["cities"]![cityIndex] as! [String: AnyObject]
                return city["areas"]![row] as? String
            }
    }
    
    //选中项改变事件（将在滑动停止后触发）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
        switch (component) {
        case 0:
            provinceIndex = row;
            cityIndex = 0;
            areaIndex = 0;
            pickerView.reloadComponent(1);
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 1, animated: false);
            pickerView.selectRow(0, inComponent: 2, animated: false);
        case 1:
            cityIndex = row;
            areaIndex = 0;
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 2, animated: false);
        case 2:
            areaIndex = row;
        default:
            break;
        }
    }
    
    //触摸按钮时，获得被选中的索引
    func getPickerViewValue(){
        //获取选中的省
        let p = self.addressArray[provinceIndex]
        let province = p["state"]!
        
        //获取选中的市
        let c = p["cities"]![cityIndex] as! [String: AnyObject]
        let city = c["city"] as! String
        
        //获取选中的县（地区）
        var area = ""
        if (c["areas"] as! [String]).count > 0 {
            area = (c["areas"] as! [String])[areaIndex]
        }
        
        //拼接输出消息
        let message = "索引：\(provinceIndex)-\(cityIndex)-\(areaIndex)\n"
            + "值：\(province) - \(city) - \(area)"
        
        //消息显示
        let alertController = UIAlertController(title: "您选择了",
                                    message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
