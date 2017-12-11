//
//  CollectionViewCell.swift
//  Berlin
//
//  Created by Bibek on 12/5/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
