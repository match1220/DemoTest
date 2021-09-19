

import UIKit

class AppListTableCell: UITableViewCell {

    @IBOutlet weak var AppRanking: UILabel!
    @IBOutlet weak var AppImage: UIImageView!
    
    
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var collectionType: UILabel!
    @IBOutlet weak var currency: UILabel!
    
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
