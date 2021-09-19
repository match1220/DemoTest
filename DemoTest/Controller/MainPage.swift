
import UIKit
import SpinningIndicator

class MainPage: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet weak var AppListTable: UITableView!
    
    @IBOutlet weak var SearchViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var FavBtn: UIButton!
    
    @IBOutlet weak var MainTitle: UILabel!
    
    var refreshControl = UIRefreshControl()
    
    var ResultAPIDataList = [ResultAPIData]()
    
    var LocalResultAPIDataList: [LocalResultAPIData] = [LocalResultAPIData]()
    var vSpinner : UIView?
    
    var successInsert : Bool!
    var FavListStatus : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        FavListStatus = false
        AppListTable.dataSource = self
        AppListTable.register(UINib(nibName: K.Cell.AppListTableCell, bundle: nil), forCellReuseIdentifier: K.Cell.AppListTableCell)
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新資料")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        AppListTable.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        GetDataAppList()
   
    }
    
   

   
    @objc func refresh(_ sender: AnyObject) {
        
        
        GetDataAppList()
    }
    
    func GetDataAppList(){
        
        
        self.showSpinner(onView: self.view)
        
        
        ModelManager.GetDataApp { ResultAPIDataList1 in
            self.ResultAPIDataList = ResultAPIDataList1

            self.AppListTable.reloadData()
            
          
            
            self.removeSpinner()
            self.refreshControl.endRefreshing()
            
            
        } blockFailed: { _ in
            
        }
        
    }
    
    
    func GetFavDataAppList(){
        
        LocalResultAPIDataList = SqliteDB.shared.queryFavData()
        
        
        self.AppListTable.reloadData()
        
        
    }
   
    @IBAction func FavBtn(_ sender: UIButton) {
        
        if FavListStatus == false {
            
            FavListStatus = true
            
            FavBtn.setImage(UIImage (systemName: "heart.fill"), for: .normal)
            
            
            MainTitle.text = "My Favourite Album"
            
            GetFavDataAppList()
            
        }
        else {
            
            
            FavListStatus = false
            
            FavBtn.setImage(UIImage (systemName: "heart"), for: .normal)
            
            MainTitle.text = "Jack Johnson Album"
            
            GetDataAppList()
        }
        
        
        
    }
    
}



//MARK: - UITableViewDataSource / UITableViewDelegate

extension MainPage:  UITableViewDataSource , UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if FavListStatus == true {
            
            return LocalResultAPIDataList.count
        }
        else{
            
            return ResultAPIDataList.count
        }
        
 
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if FavListStatus == true {
         
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.AppListTableCell, for: indexPath) as! AppListTableCell
            
            cell.AppImage.downloaded(from: LocalResultAPIDataList[indexPath.row].artworkUrl100)
            cell.collectionName.text = LocalResultAPIDataList[indexPath.row].collectionName
            cell.collectionType.text = LocalResultAPIDataList[indexPath.row].collectionType
            
            
            cell.artistName.text = LocalResultAPIDataList[indexPath.row].artistName
            
            
            cell.currency.text = LocalResultAPIDataList[indexPath.row].currency + " " + String(LocalResultAPIDataList[indexPath.row].collectionPrice)
            
         
            cell.AppImage.makeAppImageRoundedWithLine()
            
        

            cell.selectionStyle = .none


            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero

            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.AppListTableCell, for: indexPath) as! AppListTableCell
            
            cell.AppImage.downloaded(from: ResultAPIDataList[indexPath.row].artworkUrl100)
            cell.collectionName.text = ResultAPIDataList[indexPath.row].collectionName
            cell.collectionType.text = ResultAPIDataList[indexPath.row].collectionType
            
            
            cell.artistName.text = ResultAPIDataList[indexPath.row].artistName
            
            
            cell.currency.text = ResultAPIDataList[indexPath.row].currency + " " + String(ResultAPIDataList[indexPath.row].collectionPrice)
        
            cell.AppImage.makeAppImageRoundedWithLine()
            
        

            cell.selectionStyle = .none


            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero

            return cell
        }
        
       
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if FavListStatus == true {
            
            let alert = UIAlertController(title: "Remove This Album From Favourite?", message: "", preferredStyle: .actionSheet)
            
            let add = UIAlertAction(title: "Remove", style: .default) { (action) in
                
                
                SqliteDB.shared.deleteFavData(withcollectionId: self.LocalResultAPIDataList[indexPath.row].collectionId)
              
                
                self.GetFavDataAppList()
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
            }
            
            
            
            alert.addAction(add)
            alert.addAction(cancel)
            
            self.present(alert,animated: true, completion: nil)
            
        }
        else{
            
           
            let alert = UIAlertController(title: "Add This Album to Favourite?", message: "", preferredStyle: .actionSheet)
            
            let add = UIAlertAction(title: "Add", style: .default) { (action) in
                
                
                self.showSpinner(onView: self.view)
                
                self.successInsert = SqliteDB.shared.insertFavData(withcollectionId: self.ResultAPIDataList[indexPath.row].collectionId,
                                              withartworkUrl100: self.ResultAPIDataList[indexPath.row].artworkUrl100,
                                              withcollectionName: self.ResultAPIDataList[indexPath.row].collectionName,
                                              withcollectionType: self.ResultAPIDataList[indexPath.row].collectionType,
                                              withartistName: self.ResultAPIDataList[indexPath.row].artistName,
                                              withcurrency: self.ResultAPIDataList[indexPath.row].currency,
                                              withcollectionPrice: self.ResultAPIDataList[indexPath.row].collectionPrice)
                
                
                if self.successInsert == true {
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        self.removeSpinner()
                    }
                }
                else{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        self.removeSpinner()
                    }
                    
                    let alert = UIAlertController(title: "Add Failed, Please Check the Network/ Data", message: "", preferredStyle: .actionSheet)
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                        
                    }
                    
                    
                    alert.addAction(cancel)
                    
                    self.present(alert,animated: true, completion: nil)
                    
                    
                  
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
            }
            
            
            
            alert.addAction(add)
            alert.addAction(cancel)
            
            self.present(alert,animated: true, completion: nil)
            
            
        }
        
        
     
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 115
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableView.automaticDimension
        
      
    }
    
}

extension MainPage {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.color = .white
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    
  
}
