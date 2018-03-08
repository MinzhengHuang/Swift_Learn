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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //加载，处理电影列表数据
    func fetchMovieDetails() {
        //图片数据源地址
        let dataSourcePath = Bundle.main.path(forResource: "movies",
                                              ofType: "plist")
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
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int)
        -> Int {
            return movies.count
    }
    
    //创建单元格
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier",
                                                 for: indexPath) as UITableViewCell
        
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
        case .new, .downloaded:
            indicator.startAnimating()
            //只有停止拖动的时候才加载
            if (!tableView.isDragging && !tableView.isDecelerating) {
                self.startOperationsForMovieRecord(movieRecord, indexPath: indexPath)
            }
        }
        
        return cell
    }
    
    //图片任务
    func startOperationsForMovieRecord(_ movieRecord: MovieRecord, indexPath: IndexPath){
        switch (movieRecord.state) {
        case .new:
            startDownloadForRecord(movieRecord, indexPath: indexPath)
        case .downloaded:
            startFiltrationForRecord(movieRecord, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
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
    
    //视图开始滚动
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //一旦用户开始滚动屏幕，你将挂起所有任务并留意用户想要看哪些行。
        suspendAllOperations()
    }
    
    //视图停止拖动
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                           willDecelerate decelerate: Bool) {
        //如果减速（decelerate）是 false ，表示用户停止拖拽tableview。
        //此时你要继续执行之前挂起的任务，撤销不在屏幕中的cell的任务并开始在屏幕中的cell的任务。
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    //视图停止减速
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //这个代理方法告诉你tableview停止滚动，执行操作同上
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    //暂停所有队列
    func suspendAllOperations () {
        movieOperations.downloadQueue.isSuspended = true
        movieOperations.filtrationQueue.isSuspended = true
    }
    
    //恢复运行所有队列
    func resumeAllOperations () {
        movieOperations.downloadQueue.isSuspended = false
        movieOperations.filtrationQueue.isSuspended = false
    }
    
    //加载可见区域的单元格图片
    func loadImagesForOnscreenCells () {
        //开始将tableview可见行的index path放入数组中。
        if let pathsArray = self.tableView.indexPathsForVisibleRows {
            //通过组合所有下载队列和滤镜队列中的任务来创建一个包含所有等待任务的集合
            let allMovieOperations = NSMutableSet()
            for key in movieOperations.downloadsInProgress.keys{
                allMovieOperations.add(key)
            }
            for key in movieOperations.filtrationsInProgress.keys{
                allMovieOperations.add(key)
            }
            
            //构建一个需要撤销的任务的集合。从所有任务中除掉可见行的index path，
            //剩下的就是屏幕外的行所代表的任务。
            let toBeCancelled = allMovieOperations.mutableCopy() as! NSMutableSet
            let visiblePaths = NSSet(array: pathsArray)
            toBeCancelled.minus(visiblePaths as Set<NSObject>)
            
            //创建一个需要执行的任务的集合。从所有可见index path的集合中除去那些已经在等待队列中的。
            let toBeStarted = visiblePaths.mutableCopy() as! NSMutableSet
            toBeStarted.minus(allMovieOperations as Set<NSObject>)
            
            // 遍历需要撤销的任务，撤消它们，然后从 movieOperations 中去掉它们
            for indexPath in toBeCancelled {
                let indexPath = indexPath as! IndexPath
                if let movieDownload = movieOperations.downloadsInProgress[indexPath] {
                    movieDownload.cancel()
                }
                movieOperations.downloadsInProgress.removeValue(forKey: indexPath)
                if let movieFiltration = movieOperations.filtrationsInProgress[indexPath] {
                    movieFiltration.cancel()
                }
                movieOperations.filtrationsInProgress.removeValue(forKey: indexPath)
            }
            
            // 遍历需要开始的任务，调用 startOperationsForPhotoRecord
            for indexPath in toBeStarted {
                let indexPath = indexPath as! IndexPath
                let recordToProcess = self.movies[indexPath.row]
                startOperationsForMovieRecord(recordToProcess, indexPath: indexPath)
            }
        }
    }
}
