//
//  Header.swift
//  carcar
//
//  Created by Fion Liang on 3/29/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit

class Header: BaseCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func setAll(item: FormItem) {
           label.text = item.label
          
          
           
       }
}
