import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items:[String] = []
    var tableView:UITableView?
    
    // 底部加载
    let footer = MJDIYAutoFooter()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //随机生成一些初始化数据
        loadItemData()
        
        //创建表视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(self.tableView!)
        
        //上刷新相关设置
        footer.setRefreshingTarget(self, refreshingAction: #selector(ViewController.footerLoad))
        self.tableView!.mj_footer = footer
    }
    
    //初始化数据
    func loadItemData() {
        for _ in 0...20 {
            items.append("条目\(Int(arc4random()%100))")
        }
    }
    
    //顶部下拉刷新
    func footerLoad(){
        print("上拉加载.")
        sleep(2)
        //生成并添加数据
        loadItemData()
        //重现加载表格数据
        self.tableView!.reloadData()
        //结束刷新
        self.tableView!.mj_footer.endRefreshing()
    }
    
    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "SwiftCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                     for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = self.items[indexPath.row]
            return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
