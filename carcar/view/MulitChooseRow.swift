//
//  MulitChooseRow.swift
//  carcar
//
//  Created by Fion Liang on 3/29/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit

class MulitChooseRow: BaseCell {

    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var answer: UILabel!
    weak var delegate: CustomViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickToSeeMore(_ sender: Any) {
        delegate?.goToNextScene() 
    }
    
    override func setAll(item: FormItem) {
        label.text = item.label
        answer.text = ""
    }
    
}


protocol CustomViewDelegate: class {
    func goToNextScene()
}
