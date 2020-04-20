//
//  LabelCell.swift
//  carcar
//
//  Created by Fion Liang on 4/5/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
