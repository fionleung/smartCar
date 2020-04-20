//
//  CarInfo.swift
//  carcar
//
//  Created by Fion Liang on 4/1/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import Firebase

public struct CarList {
    let carName:String
    let carRef: DocumentReference
    var details = ""
    
    
    init(carname:String,carref:DocumentReference,fun:[String:Int]){
        self.carName = carname
        self.carRef = carref
        var arr : [String] = []
        for (key, value) in fun {
            if value == 1 {
                arr.append(key)
            }
        }
        self.details = "Used for : " + arr.joined(separator: ",")
    }
    
    
    init(carname:String,carref:DocumentReference,time:Timestamp?){
           self.carName = carname
           self.carRef = carref
        if let times = time{
            let date = times.dateValue()
            let formatter = DateFormatter()
                      formatter.dateFormat = "yyyy-MM-dd HH:mm"
                      self.details =  formatter.string(from: date)
        }
          
       }
}
