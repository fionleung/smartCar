//
//  FormItem.swift
//  carcar
//
//  Created by Fion Liang on 3/28/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit

struct FormItem {
    let label: String
    let celltype: CellType
    let detail: String
    
    init(label: String, celltype: CellType, detail : String) {
        self.label = label
        self.celltype = celltype
        self.detail = detail
        
    }
}
