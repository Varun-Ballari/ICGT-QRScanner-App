//
//  Match_TableViewCell.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 3/17/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import UIKit

class Match_TableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var ticketid: UILabel!
    @IBOutlet var gtid: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
