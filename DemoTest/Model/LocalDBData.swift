
import SwiftyJSON
import Foundation



class LocalResultAPIData: NSObject {
    
    var collectionId: Int
    var artworkUrl100: String
    var collectionName: String
    var collectionType: String
    var artistName: String
    var currency: String
    var collectionPrice: Double
    
    
    init(collectionId: Int,
         artworkUrl100: String,
         collectionName: String,
         collectionType: String,
         artistName: String,
         currency: String,
         collectionPrice: Double) {
        
        self.collectionId = collectionId
        self.artworkUrl100 = artworkUrl100
        self.collectionName = collectionName
        self.collectionType = collectionType
        self.artistName = artistName
        self.currency = currency
        self.collectionPrice = collectionPrice
    }
}
