import UIKit

class ViewController: UIViewController {
    
    //展示列表
    var tableView: UITableView!
    
    //搜索控制器
    var searchController = UISearchController(searchResultsController: nil)
    
    //电影集合
    var movies = [Movie]()
    
    //搜索过滤后的结果集
    var filteredMovies:[Movie] = [Movie](){
        didSet  {self.tableView.reloadData()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化音乐集合
        movies = [
            Movie(name:"杀破狼", category:"动作"),
            Movie(name:"蝙蝠侠战超人", category:"动作"),
            Movie(name:"我的少女时代", category:"爱情"),
            Movie(name:"超能陆战队", category:"动画"),
            Movie(name:"西游记之大圣归来", category:"动画")]
        
        //创建表视图
        self.tableView = UITableView(frame: self.view.frame,
                                     style:UITableViewStyle.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        self.view.addSubview(self.tableView!)
        
        //配置搜索控制器
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        //搜索状态下隐藏顶部导航栏
        searchController.hidesNavigationBarDuringPresentation = true
        
        //配置分段条
        searchController.searchBar.scopeButtonTitles = ["全部", "动作", "爱情", "动画"]
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    //根据条件过滤数据
    func filterContentForSearchText(_ searchText: String, scope: String = "全部") {
        filteredMovies = movies.filter({( movie : Movie) -> Bool in
            let categoryMatch = (scope == "全部") || (movie.category == scope)
            return categoryMatch && movie.name.lowercased().contains(
                searchText.lowercased())
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDataSource {
    //返回表格行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.searchController.isActive) {
            return self.filteredMovies.count
        } else {
            return self.movies.count
        }
    }
    
    //单元格内容设置
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                       reuseIdentifier: "myCell")
            
            if (self.searchController.isActive) {
                cell.textLabel?.text = self.filteredMovies[indexPath.row].name
                cell.detailTextLabel?.text = self.filteredMovies[indexPath.row].category
                return cell
            } else {
                cell.textLabel?.text = self.movies[indexPath.row].name
                cell.detailTextLabel?.text = self.movies[indexPath.row].category
                return cell
            }
    }
}

extension ViewController: UITableViewDelegate{
    //单元格选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    //范围分段条的选中项改变事件
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!,
                                   scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ViewController: UISearchResultsUpdating{
    //搜索栏文字改变后事件
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
