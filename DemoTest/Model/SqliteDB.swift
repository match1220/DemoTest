import UIKit


class SqliteDB: NSObject {
    
    static let shared = SqliteDB()
    
    var fileName: String = "DemoTest.sqlite"
    var filePath: String = ""
    var database: FMDatabase!
    
    
    //MARK: - FMDB Function
    
    private override init() {
        super.init()
        
        self.filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/" + self.fileName
        //
        //        print("filePath: \(self.filePath)")
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    
    func openConnection() -> Bool {
        var isOpen: Bool = false
        
        self.database = FMDatabase(path: self.filePath)
        
        if self.database != nil {
            if self.database.open() {
                isOpen = true
            } else {
                print("Could not get the connection.")
            }
        }
        
        return isOpen
    }
    
    
    
    //MARK: - Insert FavData Data
    
    
    func insertFavData(withcollectionId collectionId: Int,
                       withartworkUrl100 artworkUrl100: String,
                       withcollectionName collectionName: String,
                       withcollectionType collectionType: String,
                       withartistName artistName: String,
                       withcurrency currency: String,
                       withcollectionPrice collectionPrice: Double) -> Bool{
        
        if self.openConnection() {
            
            SqliteDB.shared.deleteFavData(withcollectionId: collectionId)
            
            let addQuery = "INSERT INTO FavAlbumTable (collectionId, artworkUrl100, collectionName, collectionType, artistName, currency, collectionPrice ) VALUES(?, ?, ?, ?, ?, ?, ?)"
            
            if !self.database.executeUpdate(addQuery, withArgumentsIn: [collectionId ,
                                                                        artworkUrl100,
                                                                        collectionName,
                                                                        collectionType,
                                                                        artistName,
                                                                        currency,
                                                                        collectionPrice]) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            
            self.database.close()
            
            return true
        }
        else{
            return false
        }
    }
    
    func deleteFavData(withcollectionId collectionId: Int){
        
        if self.openConnection() {
            
            let deleteSQL: String = "DELETE FROM FavAlbumTable where collectionId = ?"
            
            self.database.executeUpdate(deleteSQL, withArgumentsIn: [collectionId])
           
        }
       
        
    }
    
    func deleteAllFavData(){
        
        if self.openConnection() {
            
            let deleteSQL: String = "DELETE FROM FavAlbumTable"

            self.database.executeStatements(deleteSQL)
           
        }
       
        
    }
   
    func queryFavData() -> [LocalResultAPIData] {
        
        var LocalResultAPIDatas: [LocalResultAPIData] = [LocalResultAPIData]()
        
        if self.openConnection() {
            let querySQL: String = "SELECT * FROM FavAlbumTable"
            do {
                let dataLists: FMResultSet = try database.executeQuery(querySQL, values: nil)
                
                while dataLists.next() {
                    let LocalResultAPIDataData: LocalResultAPIData = LocalResultAPIData(
                        collectionId: Int(dataLists.int(forColumn: "collectionId")),
                        artworkUrl100: dataLists.string(forColumn: "artworkUrl100") ?? "",
                        collectionName: dataLists.string(forColumn: "collectionName") ?? "",
                        collectionType: dataLists.string(forColumn: "collectionType") ?? "",
                        artistName: dataLists.string(forColumn: "artistName") ?? "",
                        currency: dataLists.string(forColumn: "currency") ?? "",
                        collectionPrice: Double(dataLists.double(forColumn: "collectionPrice")))
                    
                    
                    
                    LocalResultAPIDatas.append(LocalResultAPIDataData)
                    
                    
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return LocalResultAPIDatas
    }
    
    
  
}
