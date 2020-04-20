//
//  taskListCell.swift
//  carcar
//
//  Created by Fion Liang on 4/9/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit

class taskListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
