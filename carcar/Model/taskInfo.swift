//
//  taskInfo.swift
//  carcar
//
//  Created by Fion Liang on 4/8/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import Firebase

public struct taskInfo{
   let name: String
   let owner: String
    let status: String
    let ref: DocumentReference
    let detail: String
    
    init(doc:QueryDocumentSnapshot){
        self.name = doc["name"] as? String ?? "None"
        self.owner = doc["owner"] as?String ?? "None"
        self.status = doc["status"] as? String ?? "None"
        self.ref = doc.reference
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        var detail = ""
        if self.status == K.FStore.schStatus {
            if let time = doc["startTime"] as? Timestamp {
                detail =  "Task will start at :" + formatter.string(from: time.dateValue())
            }
        }else if self.status == K.FStore.busyStatus {
            if let time = doc["startTime"] as? Timestamp {
                detail =  "Task started at :" + formatter.string(from: time.dateValue())
            }
        }
        self.detail = detail
    }
}

public struct taskDetail{
    
    var name :String = "--"
    var status: String = "--"
    var destination: String = "--"
    var tasktype: String = "--"
    var starttime: String = "--"
    var finishtime: String = "--"
    var owner: String = "--"
    var car: String = "--"
   
       
    init(doc:[String:Any]){
        if let name = doc["name"] as? String {
            self.name = name
        }
        if let car = doc["car"] as? String {
                   self.car = car
               }
        if let owner = doc["owner"] as?String{
            self.owner = owner
        }
        if let status = doc["status"] as? String{
            self.status = status
        }
        if let date = doc["startTime"] as? Timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.starttime = formatter.string(from: date.dateValue())
        }
        if let date = doc["finishTime"] as? Timestamp {
                  let formatter = DateFormatter()
                  formatter.dateFormat = "yyyy-MM-dd HH:mm"
                  self.finishtime = formatter.string(from: date.dateValue())
        }
        if let loc = doc["destination"] as?  [String:Float64] {
            if let lat = loc["latitude"]  ,let lon = loc["longitude"] {
                let lat = String(format:"%.4f", lat)
                 let lon = String(format:"%.4f", lon)
                  self.destination = "\(lat), \(lon)"
            }
          
       }
        if let fun = doc["function"] as? [String:Int] {
            var arr : [String] = []
            for (key, value) in fun {
                if value == 1 {
                    arr.append(key)
                }
            }
            self.tasktype = arr.joined(separator: ",")
        }
        
}
}

public struct taskSum {
   var carname :String = "--"
    var taskname :String = "--"
    var status: String = "--"
    var detail: String = "--"
    
    init(doc:[String:Any]){
    if let taskname = doc["name"] as? String {
        self.taskname = taskname
    }
    if let status = doc["status"] as? String{
               self.status = status
           }
    var carname = ""
    var time = ""
    if let car = doc["car"] as? String {
            carname = car
        }
        if self.status == "scheduled", let date = doc["startTime"] as? Timestamp {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        time = " will operate on " + formatter.string(from: date.dateValue())
    }
       else if self.status == "working", let date = doc["startTime"] as? Timestamp {
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd HH:mm"
              time = " has started at " + formatter.string(from: date.dateValue())
          }
       else if self.status == "finished", let date = doc["finishTime"] as? Timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            time = " has finished task at " + formatter.string(from: date.dateValue())
        }
        else  {
            if let date = doc["startTime"] as? Timestamp {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                time = " was scheduled to operate on " + formatter.string(from: date.dateValue())
            }
        }
        
        self.detail = carname + time
}
}
