//
//  SubmitButtonCell.swift
//  carcar
//
//  Created by Fion Liang on 4/1/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Eureka


final class SubmitButtonCell: Cell<String>, CellType {
    
   
    @IBOutlet weak var buttonLabel: UILabel!
    
    @IBOutlet weak var ButtonView: UIView!
    
    var values: [String:Any?] = [:]
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                super.init(style: style, reuseIdentifier: reuseIdentifier)
               
            }

            required init?(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)
            }

            override func setup() {
                super.setup()
                }


            override func update() {
                super.update()
                ButtonView.layer.cornerRadius = ButtonView.frame.size.height / 5
                }
    
            override func layoutSubviews() {
            super.layoutSubviews()
            subviews.forEach { (view) in
                if type(of: view).description() == "_UITableViewCellSeparatorView" {
                    view.isHidden = true
            }
        }
    }
    
    override func didSelect() {
           super.didSelect()
           row.deselect()
       }
            }
            
    

final class SubmitButtonRow: Row<SubmitButtonCell>, RowType {
    var presentationMode: PresentationMode<UIViewController>?
    
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<SubmitButtonCell>(nibName: "SubmitButtonCell")
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let presentationMode = presentationMode {
                if let controller = presentationMode.makeController() {
                    presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
                } else {
                    presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
                }
            }
        }
    }

    override func customUpdateCell() {
        super.customUpdateCell()
        
    }

    override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        (segue.destination as? RowControllerType)?.onDismissCallback = presentationMode?.onDismissCallback
    }
    
}

