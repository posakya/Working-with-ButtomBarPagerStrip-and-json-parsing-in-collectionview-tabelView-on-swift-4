//
//  TableViewCell.swift
//  Berlin
//
//  Created by Bibek on 12/8/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let lineFrame = CGRect(x: 0, y: 10, width: bounds.size.width, height: 5)
//        let line = UIView(frame: lineFrame)
//        line.backgroundColor = UIColor.lightGray
//        addSubview(line)
        
//        let screenSize = UIScreen.main.bounds
//        let separatorHeight = CGFloat(7.0)
//        let additionalSeparator = UIView.init(frame: CGRect(x: 0, y: screenSize, width: screenSize.width, height: separatorHeight))
//        additionalSeparator.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
//        self.addSubview(additionalSeparator)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let f = contentView.frame
        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 10, 10))
        contentView.frame = fr
    }
    
}
