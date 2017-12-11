//
//  MenuTableViewCell.swift
//  Berlin
//
//  Created by Bibek on 12/1/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var uiText: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
