
import SwiftyJSON
import Foundation





struct ResultAPIData : Decodable{
    var wrapperType: String
    var collectionType: String
    var artistId: Int
    var collectionId: Int
    var amgArtistId: Int
    var artistName: String
    var collectionName: String
    var collectionCensoredName: String
    var artistViewUrl: String
    var collectionViewUrl: String
    var artworkUrl60: String
    var artworkUrl100: String
    var collectionPrice: Double
    var collectionExplicitness: String
    var trackCount: Int
    var copyright: String
    var country: String
    var currency: String
    var releaseDate: String
    var primaryGenreName: String
   
   
   
    
    init(json: JSON) {
        self.wrapperType = json["wrapperType"].stringValue
        self.collectionType = json["collectionType"].stringValue
        self.artistId = json["artistId"].intValue
        self.collectionId = json["collectionId"].intValue
        self.amgArtistId = json["amgArtistId"].intValue
        self.artistName = json["artistName"].stringValue
        self.collectionName = json["collectionName"].stringValue
        self.collectionCensoredName = json["collectionCensoredName"].stringValue
        self.artistViewUrl = json["artistViewUrl"].stringValue
        self.collectionViewUrl = json["collectionViewUrl"].stringValue
        self.artworkUrl60 = json["artworkUrl60"].stringValue
        self.artworkUrl100 = json["artworkUrl100"].stringValue
        self.collectionPrice = json["collectionPrice"].doubleValue
        self.collectionExplicitness = json["collectionExplicitness"].stringValue
        self.trackCount = json["trackCount"].intValue
        self.copyright = json["copyright"].stringValue
        self.country = json["country"].stringValue
        self.currency = json["currency"].stringValue
        self.releaseDate = json["releaseDate"].stringValue
        self.primaryGenreName = json["primaryGenreName"].stringValue
       
    }
}
