//
//  CellType.swift
//  carcar
//
//  Created by Fion Liang on 3/28/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import Foundation
import UIKit

enum CellType{
    
    case text
    case header
    case multi
    
    
    func getClass() -> BaseCell.Type{
        switch self {
        case .text: return TextRow.self
        case .header: return Header.self
        case .multi: return MulitChooseRow.self
        }
    }
    
    func getIdentifier() -> String{
        switch self {
        case .text: return "TextRowCell"
        case .header: return "HeaderCell"
        case .multi: return "MulitChooseCell"
        }
    }
    
}
