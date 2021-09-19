
import UIKit
import Alamofire
import SwiftyJSON


class ModelManager: NSObject {
    
    
    
    override init() {
        
        super.init()
    }
    
    
    //MARK: - API Get Data
    
    class func GetDataApp(completion: @escaping  ([ResultAPIData]) -> Void ,
                                     blockFailed failed: @escaping (_ error:String?)->()){
   
        
        AF.request("https://itunes.apple.com/search?term=jack+johnson&entity=album",method: .get).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
              
                    let list = json["results"].arrayValue
                    var DataAPI = [ResultAPIData]()
                    
                    for APIJson in list {
                        let APIdata = ResultAPIData(json: APIJson)
                        DataAPI.append(APIdata)
                        
                    }
                
                    
                    completion(DataAPI)
                
             
            
            case .failure(let error):
                print(error)
                failed("")
            }
            
        }
        
    }
    
    
    

}
