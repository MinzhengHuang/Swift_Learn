
import UIKit
import CoreImage

//图片数据源地址
let dataSourcePath = Bundle.main.path(forResource: "movies", ofType: "plist")

class ListViewController: UITableViewController {
    
    //电影图片字典集合（使用了懒加载）
    lazy var movies = NSDictionary(contentsOfFile: dataSourcePath!)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "热门电影"
    }
    
    //获取记录数
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //创建单元格
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier",for: indexPath) as UITableViewCell
        
        //设置单元格文本
        let rowKey = movies.allKeys[indexPath.row] as! String
        cell.textLabel?.text = rowKey
        
        //设置单元格图片
        var image : UIImage?
        if let imageURL = URL(string:movies[rowKey] as! String) {
            let imageData = try? Data(contentsOf: imageURL)
            let unfilteredImage = UIImage(data:imageData!)
            image = self.applySepiaFilter(unfilteredImage!)
        }
        
        if image != nil {
            cell.imageView?.image = image!
        }else{
            //cell.imageView?.image = nil //未加载到海报则空白
            cell.imageView?.image = UIImage(named: "failed") //未加载到海报显示默认的“暂无图片”
        }
        
        return cell
    }
    
    //给图片添加棕褐色滤镜
    func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:UIImagePNGRepresentation(image)!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter!.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: "inputIntensity")
        if let outputImage = filter!.outputImage {
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage(cgImage: outImage!)
        }
        return nil
    }
}
