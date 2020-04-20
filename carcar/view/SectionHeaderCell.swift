//
//  SectionHeaderCell.swift
//  carcar
//
//  Created by Fion Liang on 4/5/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit





class SectionHeaderCell: UITableViewHeaderFooterView {

   let title = UILabel()
        let image = UIImageView()

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
           
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
       
    }
