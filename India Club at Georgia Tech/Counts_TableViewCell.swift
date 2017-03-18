//
//  Counts_TableViewCell.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/16/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit

class Counts_TableViewCell: UITableViewCell {

    @IBOutlet var eventName: UILabel!
    @IBOutlet var checkedIn: UILabel!
    @IBOutlet var registered: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
