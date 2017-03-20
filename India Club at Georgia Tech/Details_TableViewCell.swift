//
//  DetailsTableViewCell.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/20/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit

class Details_TableViewCell: UITableViewCell {

    @IBOutlet var labelType: UILabel!
    @IBOutlet var result: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
