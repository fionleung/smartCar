//
//  AddCarFormInfo.swift
//  carcar
//
//  Created by Fion Liang on 3/28/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
 
struct AddCarFormInfo {
   
    let item=[
        FormItem(label:"Hardware",celltype: .header, detail: ""),
        FormItem(label:"hardware1",celltype: .text, detail: "e.g.,CPU"),
        FormItem(label:"hardware2",celltype: .text, detail: "e.g.,CPU"),
        FormItem(label:"Software",celltype: .header, detail: ""),
        FormItem(label:"software1",celltype: .text, detail: "e.g.,system version"),
        FormItem(label:"software2",celltype: .text, detail: "e.g.,map version"),
        FormItem(label:"Function",celltype: .header, detail: ""),
        FormItem(label:"function",celltype: .multi, detail: "mulitiply choice?"),
        FormItem(label:"Operator",celltype: .header, detail: ""),
        FormItem(label:"Email",celltype: .text, detail: "who can run the car")
    ]
    
   





}
