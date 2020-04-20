//
//  TextRow.swift
//  carcar
//
//  Created by Fion Liang on 3/28/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit

class TextRow: BaseCell {

    
    
    @IBOutlet fileprivate weak var label: UILabel!
    
   
    @IBOutlet fileprivate weak var answer: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setAll(item: FormItem) {
        label.text = item.label
        answer.attributedPlaceholder = NSAttributedString(string: item.detail, attributes: [NSAttributedString.Key.foregroundColor:UIColor(named:"greyBlue-2")])
    }
   
}

extension TextRow: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
