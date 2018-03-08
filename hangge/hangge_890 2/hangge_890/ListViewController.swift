
import UIKit
import CoreImage

class ListViewController: UITableViewController {
    
    var movies = [MovieRecord]()
    let movieOperations = MovieOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "热门电影"
        
        //加载，处理电影列表数据
        fetchMovieDetails();
    }
    
    //加载，处理电影列表数据
    func fetchMovieDetails() {
        //图片数据源地址
        let dataSourcePath = Bundle.main.path(forResource: "movies", ofType: "plist")
        let datasourceDictionary = NSDictionary(contentsOfFile: dataSourcePath!)
        
        for(key,value) in datasourceDictionary!{
            let name = key as? String
            let url = URL(string:value as? String ?? "")
            if name != nil && url != nil {
                let movieRecord = MovieRecord(name:name!, url:url!)
                self.movies.append(movieRecord)
            }
        }
        
        self.tableView.reloadData()
    }
    
    //获取记录数
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //创建单元格
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
            
            //为了提示用户，将cell的accessory view设置为UIActivityIndicatorView。
            if cell.accessoryView == nil {
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                cell.accessoryView = indicator
            }
            let indicator = cell.accessoryView as! UIActivityIndicatorView
            
            //获取当前行所对应的电影记录。
            let movieRecord = movies[indexPath.row]
            
            //设置文本和图片
            cell.textLabel?.text = movieRecord.name
            cell.imageView?.image = movieRecord.image
            
            //检查图片状态。设置适当的activity indicator 和文本，然后开始执行任务
            switch (movieRecord.state){
            case .filtered:
                indicator.stopAnimating()
            case .failed:
                indicator.stopAnimating()
                cell.textLabel?.text = "Failed to load"
            case .new:
                indicator.startAnimating()
                startDownloadForRecord(movieRecord, indexPath: indexPath)
            case .downloaded:
                indicator.startAnimating()
                startFiltrationForRecord(movieRecord, indexPath: indexPath)
            }
            
            return cell
    }
    
    //执行图片下载任务
    func startDownloadForRecord(_ movieRecord: MovieRecord, indexPath: IndexPath){
        //判断队列中是否已有该图片任务
        if let _ = movieOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //创建一个下载任务
        let downloader = ImageDownloader(movieRecord: movieRecord)
        //任务完成后重新加载对应的单元格
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.movieOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
        }
        //记录当前下载任务
        movieOperations.downloadsInProgress[indexPath] = downloader
        //将任务添加到队列中
        movieOperations.downloadQueue.addOperation(downloader)
    }
    
    //执行图片滤镜任务
    func startFiltrationForRecord(_ movieRecord: MovieRecord, indexPath: IndexPath){
        if let _ = movieOperations.filtrationsInProgress[indexPath]{
            return
        }
        
        let filterer = ImageFiltration(movieRecord: movieRecord)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.movieOperations.filtrationsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
        }
        movieOperations.filtrationsInProgress[indexPath] = filterer
        movieOperations.filtrationQueue.addOperation(filterer)
    }
}
