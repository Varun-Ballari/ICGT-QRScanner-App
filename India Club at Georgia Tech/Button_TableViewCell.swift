//
//  Button_TableViewCell.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/20/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit

class Button_TableViewCell: UITableViewCell {

    @IBOutlet var buttonLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buttonLabel.layer.cornerRadius = 5
        buttonLabel.clipsToBounds = true
        buttonLabel.layer.borderColor = UIColor.init(rgb: 0x4898FA, alpha: 1.0).cgColor
        buttonLabel.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
