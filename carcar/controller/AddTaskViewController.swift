//
//  AddTaskViewController.swift
//  carcar
//
//  Created by Fion Liang on 4/1/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//



import UIKit
import Eureka
import MapKit
import Firebase

class AddTaskViewController: FormViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    var cars : [String : DocumentReference] = [:]
    var altrue = true

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Task"
        createForm()
    }
    
    func createForm(){
        tableView.backgroundColor = UIColor(named:"greyBlue-0")
        TextRow.defaultCellUpdate = { cell, row in
            //            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .thin)
            row.title=row.tag
            cell.textLabel?.textColor = UIColor(named:"gold-2")
            cell.backgroundColor = UIColor.white
            cell.tintColor = UIColor.darkGray
            cell.textField.textColor = UIColor.darkGray
        }
        
        
        
        
        DateTimeRow.defaultCellUpdate = { cell, row in
            row.title=row.tag
            cell.textLabel?.textColor = UIColor(named:"gold-2")
            cell.detailTextLabel?.textColor = UIColor.darkGray
            cell.backgroundColor = UIColor.white
            cell.tintColor = UIColor.darkGray
            cell.datePicker.minimumDate = Date()
        }
        PushRow<String>.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor(named:"gold-2")
            cell.tintColor = UIColor(named:"greyBlue-5")
            cell.detailTextLabel?.textColor = UIColor.darkGray
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = UIImageView(image: UIImage(named: "arrow"))
        }
        
        MultipleSelectorRow<String>.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor(named:"gold-2")
            cell.tintColor = UIColor(named:"greyBlue-5")
            cell.detailTextLabel?.textColor = UIColor.darkGray
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = UIImageView(image: UIImage(named: "arrow"))
        }
        LabelRow.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            
        }
        
        form +++ Section("New task details:")
            <<< LabelRow("err"){
                $0.hidden = true
            }.cellUpdate{(cell,row) in
                cell.height = {100}
            }
            <<< TextRow("Task Name"){
               
                $0.placeholder = "enter here"
                $0.placeholderColor = UIColor.lightGray
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }
            <<< DateTimeRow("Time to start"){
                $0.title = $0.tag
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }
            <<< LocationRow("Destination"){
                $0.title = $0.tag
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }.cellUpdate { cell, row in
                cell.backgroundColor = UIColor.white
                cell.textLabel?.textColor = UIColor(named:"gold-2")
                cell.tintColor = UIColor(named:"greyBlue-5")
                cell.detailTextLabel?.textColor = UIColor.darkGray
            }.onCellSelection { cell, row in
                cell.detailTextLabel?.textColor = UIColor.red
                
            }
            <<< MultipleSelectorRow<String>("Task Type"){
                $0.title = $0.tag
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                $0.selectorTitle = ""
                $0.optionsProvider = .lazy({ (form, completion) in
                    form.tableView.backgroundColor = UIColor(named:"greyBlue-0")
                    completion([K.CarAtt.function1,K.CarAtt.function2,K.CarAtt.function3])
                })
            }.onPresent { from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(AddCarViewController.multipleSelectorDone(_:)))
                to.selectableRowCellUpdate = {cell, row in
                    cell.textLabel?.textColor = UIColor(named:"gold-2")
                    cell.backgroundColor = UIColor.white
                    cell.tintColor = #colorLiteral(red: 0.07539536804, green: 0.1575077474, blue: 0.2254666686, alpha: 1)
                }
            }.onChange{ row in
                let err = self.form.rowBy(tag: "err1") as? LabelRow
                err?.hidden = Condition.init(booleanLiteral: !(row.value?.isEmpty ?? true))
                err?.evaluateHidden()
                err?.updateCell()
                let fun = self.form.rowBy(tag:"Choose a car to perform the task") as? PushRow<String>
                fun?.disabled = Condition.init(booleanLiteral: row.value?.isEmpty ?? true)
                fun?.value = nil
                fun?.evaluateDisabled()
                fun?.updateCell()
                
            }
            <<< LabelRow("err1"){
                $0.title = "Please pick at least one task type!"
                $0.hidden = true
            }.cellUpdate {cell, row in
                cell.height = {30}
            }
            <<< PushRow<String>("Choose a car to perform the task") {
                $0.title = $0.tag
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                $0.selectorTitle = ""
                $0.disabled = Condition.function(["Task Type"], { form in
                    return self.form.values()["Task Type"] as? String == nil
                })
                $0.optionsProvider = .lazy({ (form, completion) in
                    form.tableView.backgroundColor = UIColor(named:"greyBlue-0")
                    self.cars = [:]
                    let tempvalue = self.form.values()
                    if  let owner = Auth.auth().currentUser?.email, let function = tempvalue["Task Type"] as? Set<String> {

                        let ref = self.db.collection(K.FStore.carCollection)
                        var query = ref.whereField("status", isEqualTo: K.FStore.avaStatus)
                        query = query.whereField(K.FStore.people, arrayContains: owner)
                           
                        if (function.contains(K.CarAtt.function1))  {query = query.whereField(K.FStore.function1, isEqualTo: true)}
                        if (function.contains(K.CarAtt.function2))  {query = query.whereField(K.FStore.function2, isEqualTo: true)}
                        if (function.contains(K.CarAtt.function3))  {query = query.whereField(K.FStore.function3, isEqualTo: true)}
                        query.getDocuments(){ (querySnapshot, err) in
                            if let err = err {
                                Alert.errAlert(on: self, with: "oooops", has: err.localizedDescription,to:"try again")
                            } else {
                                if querySnapshot?.count == 0{
                                    Alert.errAlert(on: self, with: "oooops", has: "No car is available now",to:"try again")
                                }
                                else if let snapshotDocuments = querySnapshot?.documents {
                                    for doc in snapshotDocuments {
                                        let data = doc.data()
                                        if let name = data["name"] as? String {
                                            self.cars[name] = doc.reference
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        completion(self.cars.map{$0.key})
                                    }
                                }
                            }
                        }
                        
                    }
                })
            }.onPresent { from, to in
                to.selectableRowCellUpdate = {cell, row in
                    cell.textLabel?.textColor = UIColor(named:"gold-2")
                    cell.backgroundColor = UIColor.white
                    cell.tintColor = #colorLiteral(red: 0.07539536804, green: 0.1575077474, blue: 0.2254666686, alpha: 1)
                    
                }
            }.onCellSelection{ cell, row in
                if self.form.values()["Task Type"] as? String == nil {
                    let cel = self.form.rowBy(tag: "err1") as? LabelRow
                    cel?.hidden = Condition.function(["Task Type"], { form in
                        let tasktype = self.form.rowBy(tag: "Task Type") as? MultipleSelectorRow<String>
                        return !(tasktype?.value?.isEmpty ?? true)
                    })
                    cel?.evaluateHidden()
                    cel?.updateCell()
                }
            }
            +++ Section()
            <<< SubmitButtonRow(){
                $0.cell.buttonLabel.text="CREATE TASK"
            }.onCellSelection{ cell, row in
                let allvalue=self.form.values()
                self.uploadData(task:allvalue)
                
        }
    }
    
    
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: false)
    }
    
    func uploadData(task:[String:Any?]){
        form.validate()
        var msg = " "
        var line = 1
        self.altrue = true
        
        for row in form.allRows{
            if !row.isValid {
                msg += "\n\(row.tag!)"
                self.altrue = false
                line += 1
            }
        }
        
        if !self.altrue {
            let row = form.rowBy(tag: "err") as? LabelRow
            row?.hidden = false
            row?.evaluateHidden()
            row?.title = "Please enter :" + msg
            row?.cell.textLabel?.numberOfLines = line
            row?.updateCell()
        }
        
        
        
        if  self.altrue,
            let owner = Auth.auth().currentUser?.email, let name = task["Task Name"] as? String,
            let function = task["Task Type"] as? Set<String>,
            let startTime = task["Time to start"] as? Date,
            let car = task["Choose a car to perform the task"] as? String,
            let ref = cars[car],
            let destination = task["Destination"] as? CLLocation
        {
            //function setup
            var carfunction = [K.CarAtt.function1:false,K.CarAtt.function2:false,K.CarAtt.function3:false]
            function.map{carfunction[$0] = true}
            
            //upload data
            ref.collection(K.FStore.taskList).addDocument(data: [
                "owner": owner,
                "name":name,
                "function":carfunction,
                "startTime":startTime,
                "status":K.FStore.schStatus,
                "car": car,
                "destination":[
                    "latitude":destination.coordinate.latitude,
                    "longitude":destination.coordinate.longitude
                ]

            ]) { (error) in
                if let e = error {
                    Alert.errAlert(on: self, with: "ooops", has: e.localizedDescription,to:"Try again")
                }
            }
           
            ref.updateData([
                "status": K.FStore.schStatus,
                "scheduletime":startTime
            ]){ (error) in
                if let e = error {
                    Alert.errAlert(on: self, with: "ooops", has: e.localizedDescription,to:"Try again")
                } else {
                    DispatchQueue.main.async {
                        Alert.showBasicAlert(on: self, with: name, has: "was successfully scheduled", to: "backList")
                    }
                    
                }
            }
            
            
        }
    }
    
    
}


