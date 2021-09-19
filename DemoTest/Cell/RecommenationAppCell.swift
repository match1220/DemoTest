//
//  RecommenationAppCell.swift
//  hk01demotest
//
//  Created by TsuiMan kit on 6/8/2021.
//

import UIKit

class RecommenationAppCell: UICollectionViewCell {

    
    @IBOutlet weak var AppImage: UIImageView!
    @IBOutlet weak var AppName: UILabel!
    @IBOutlet weak var AppType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        AppImage.makeAppImageRounded()
    }

}
