//
//  AddCarViewController.swift
//  carcar
//
//  Created by Fion Liang on 3/27/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class AddCarViewController: FormViewController {
    
    let db = Firestore.firestore()
    var alright = true
    var car : [String: String] = [:]
    var carInfo : [String:String] = [:]
    var editMood = false
    var carref :DocumentReference? = nil
    var functionSet = Set<String>()
    var people : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add a Car"
        if self.editMood {
            title = "Update Car Info"
        }
        createForm()
    }
    
    //create form
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
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.white
            cell.tintColor = UIColor.darkGray
            cell.textField.textColor = UIColor.darkGray
        }
        
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.white
            cell.tintColor = UIColor.darkGray
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
            cell.height = { 30 }
        }
        
        form +++ Section()
            <<< LabelRow("err1"){
                $0.title = "Please fill the follow blank"
                $0.hidden = Condition.function(["Name"], { form in
                    return (form.rowBy(tag: "Name") as? TextRow)?.validationErrors.isEmpty ?? true
                })
            }
            <<< TextRow("Name"){
                $0.value = self.carInfo["name"]
                $0.placeholder = "enter here"
                $0.placeholderColor = UIColor.lightGray
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }
            
            
            +++ Section("Hardware")
            <<< LabelRow("err2"){
                $0.title = "Please fill the follow blank"
                $0.hidden = Condition.function([K.CarAtt.attibute1], { form in
                    return (form.rowBy(tag: K.CarAtt.attibute1) as? TextRow)?.validationErrors.isEmpty ?? true
                })
            }
            <<< TextRow(K.CarAtt.attibute1){
                $0.value = self.carInfo[K.CarAtt.attibute1]
                $0.placeholder = "cpu?"
                $0.placeholderColor = UIColor.lightGray
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
            }
            <<< LabelRow("err3"){
                $0.title = "Please fill the follow blank"
                $0.hidden = Condition.function([K.CarAtt.attibute2], { form in
                    return (form.rowBy(tag: K.CarAtt.attibute2) as? TextRow)?.validationErrors.isEmpty ?? true
                })
            }
            <<< TextRow(K.CarAtt.attibute2){
                $0.value = self.carInfo[K.CarAtt.attibute2]
                $0.placeholder = "battery?"
                $0.placeholderColor = UIColor.lightGray
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                
            }
            +++ Section("Software")
            <<< LabelRow("err4"){
                $0.title = "Please fill the follow blank"
                $0.hidden = Condition.function([K.CarAtt.attibute3], { form in
                    return (form.rowBy(tag: K.CarAtt.attibute3) as? TextRow)?.validationErrors.isEmpty ?? true
                })
            }
            <<< TextRow(K.CarAtt.attibute3){
                $0.value = self.carInfo[K.CarAtt.attibute3]
                $0.placeholder = "os?"
                $0.placeholderColor = UIColor.lightGray
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                
            }
            <<< LabelRow("err5"){
                $0.title = "Please fill the follow blank"
                $0.hidden = Condition.function([K.CarAtt.attibute4], { form in
                    return (form.rowBy(tag: K.CarAtt.attibute4) as? TextRow)?.validationErrors.isEmpty ?? true
                })
            }
            <<< TextRow(K.CarAtt.attibute4){
                $0.value = self.carInfo[K.CarAtt.attibute4]
                $0.placeholder = "map version?"
                $0.placeholderColor = UIColor.lightGray
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                
            }
            +++ Section("Function")
            <<< LabelRow("err6"){
                
                $0.title = "Please pick at least one function"
                $0.hidden = Condition.function(["Function"], { form in
                    return (form.rowBy(tag: "Function") as? MultipleSelectorRow<String>)?.validationErrors.isEmpty ?? true
                })
            }
            <<< MultipleSelectorRow<String>("Function"){
                $0.title = $0.tag
                $0.value = self.functionSet
                $0.selectorTitle = "Click all functions applied"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnDemand
                $0.optionsProvider = .lazy({ (form, completion) in
                    form.tableView.backgroundColor = UIColor(named:"greyBlue-0")
                    completion([K.CarAtt.function1,K.CarAtt.function2,K.CarAtt.function3])
                })
            }.onPresent { from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(AddCarViewController.multipleSelectorDone(_:)))
                to.selectableRowCellUpdate = {cell, row in
                    cell.textLabel?.textColor = UIColor(named:"gold-2")
                    cell.backgroundColor = UIColor.white
                    cell.tintColor = #colorLiteral(red: 0.07032807916, green: 0.1417779326, blue: 0.2012594044, alpha: 1)
                }
            }
            
            +++  MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                    header: "Operator",
                                    footer: "Add other operators's email If there are people other than you have premission to operate and view the car."){
                                        $0.tag="Operator"
                                        $0.addButtonProvider = { section in
                                            return ButtonRow(){
                                                $0.title = "+ Operator"
                                                
                                            }
                                        }
                                        
                                        
                                        $0.multivaluedRowToInsertAt = { index in
                                            return EmailRow() {
                                                if (self.people.count>index){
                                                    $0.value = self.people[index]
                                                }
                                                $0.placeholder = "Email"
                                                $0.placeholderColor = UIColor(named:"gold-2")
                                                $0.add(rule: RuleEmail())
                                                $0.validationOptions = .validatesOnChangeAfterBlurred
                                            }.onRowValidationChanged { cell, row in
                                                let rowIndex = row.indexPath!.row
                                                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                                                    row.section?.remove(at: rowIndex + 1)
                                                    
                                                }
                                                if !row.isValid {
                                                    
                                                    let labelRow = LabelRow() {
                                                        $0.title = "Please enter a valid email"
                                                    }
                                                    let indexPath = row.indexPath!.row + 1
                                                    row.section?.insert(labelRow, at: indexPath)
                                                }
                                            }
                                        }
                                        
                                        $0 <<< EmailRow() {
                                            $0.placeholder = "Email"
                                            $0.placeholderColor = UIColor(named:"gold-2")
                                            if (self.people.count>0){
                                                $0.value = self.people[0]
                                            }
                                            $0.add(rule: RuleEmail())
                                            $0.validationOptions = .validatesOnChangeAfterBlurred
                                        }.onRowValidationChanged { cell, row in
                                            let rowIndex = row.indexPath!.row
                                            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                                                row.section?.remove(at: rowIndex + 1)
                                                
                                            }
                                            if !row.isValid {
                                                
                                                let labelRow = LabelRow() {
                                                    $0.title = "Please enter a valid email"
                                                }
                                                let indexPath = row.indexPath!.row + 1
                                                row.section?.insert(labelRow, at: indexPath)
                                            }
                                            
                                        }
                                        if self.people.count>1{
                                            for i in 1...self.people.count-1 {
                                                $0 <<< EmailRow() {
                                                    $0.placeholder = "Email"
                                                    $0.placeholderColor = UIColor(named:"gold-2")
                                                    if (self.people.count>0){
                                                        $0.value = self.people[i]
                                                    }
                                                    $0.add(rule: RuleEmail())
                                                    $0.validationOptions = .validatesOnChangeAfterBlurred
                                                }.onRowValidationChanged { cell, row in
                                                    let rowIndex = row.indexPath!.row
                                                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                                                        row.section?.remove(at: rowIndex + 1)
                                                        
                                                    }
                                                    if !row.isValid {
                                                        
                                                        let labelRow = LabelRow() {
                                                            $0.title = "Please enter a valid email"
                                                        }
                                                        let indexPath = row.indexPath!.row + 1
                                                        row.section?.insert(labelRow, at: indexPath)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        
            }
            
            +++ Section()
            <<< SubmitButtonRow(){
                $0.cell.buttonLabel.text="SUBMIT"
                $0.cell.height = {38}
            }.onCellSelection{ cell, row in
                let cardata=self.form.values()
                if (self.editMood) {
                    self.editData(cardata: cardata)
                }else{
                    self.uploadData(cardata: cardata)
                }
                
        }
        
    }
    
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    
    func uploadData(cardata:[String:Any?]){
        self.alright = true
        form.validate()
        for tag in ["err1","err2","err3","err4","err5","err6"]{
            let errorrow = self.form.rowBy(tag: tag) as! LabelRow
            errorrow .evaluateHidden()
            errorrow.updateCell()
        }
        for row in form.allRows{
            if row.isValid == false {
                self.alright = false
            }
        }
        if  self.alright,
            let owner = Auth.auth().currentUser?.email, let name = cardata["Name"] as? String,
            let hardware1 = cardata[K.CarAtt.attibute1] as? String, let hardware2 =  cardata[K.CarAtt.attibute2] as? String,
            let function = cardata["Function"] as? Set<String>,
            let software1 = cardata[K.CarAtt.attibute3] as? String, let software2 = cardata[K.CarAtt.attibute4] as? String {
            //function setup
            var carfunction = [K.CarAtt.function1:false,K.CarAtt.function2:false,K.CarAtt.function3:false]
            function.map{carfunction[$0] = true}
            //role setup
            var people :[String] = []
            
            if let op = cardata["Operator"] as? [String]{
                people = op
            }
            people.append(owner)
            var role :[String:Any?] = [:]
            role["owner"] = owner
            role["operator"] = people
            //upload data
            let newRef = db.collection(K.FStore.carCollection).document()
            newRef.setData([
                "name":name,
                "create time":FieldValue.serverTimestamp(),
                K.CarAtt.attibute1:hardware1,
                K.CarAtt.attibute2:hardware2,
                "function":carfunction,
                K.CarAtt.attibute3:software1,
                K.CarAtt.attibute4:software2,
                "role":role,
                "status": K.FStore.avaStatus
                
            ]) { (error) in
                if let e = error {
                    Alert.errAlert(on: self, with: "ooops", has: e.localizedDescription,to:"Try again")
                } else {
                    DispatchQueue.main.async {
                        Alert.showBasicAlert(on: self, with: "\(name)",has:"has successfully added!",to:"backHome")
                    }
                }
            }
        }
    }
    
    func editData(cardata:[String:Any?]){
        self.alright = true
        form.validate()
        for tag in ["err1","err2","err3","err4","err5","err6"]{
            let errorrow = self.form.rowBy(tag: tag) as! LabelRow
            errorrow .evaluateHidden()
            errorrow.updateCell()
        }
        for row in form.allRows{
            if row.isValid == false {
                self.alright = false
            }
        }
        if  self.alright,
            let owner = Auth.auth().currentUser?.email, let name = cardata["Name"] as? String,
            let hardware1 = cardata[K.CarAtt.attibute1] as? String, let hardware2 =  cardata[K.CarAtt.attibute2] as? String,
            let function = cardata["Function"] as? Set<String>,
            let software1 = cardata[K.CarAtt.attibute3] as? String, let software2 = cardata[K.CarAtt.attibute4] as? String {
            //function setup
            var carfunction = [K.CarAtt.function1:false,K.CarAtt.function2:false,K.CarAtt.function3:false]
            function.map{carfunction[$0] = true}
            //role setup
            var people :[String] = []
            
            if let op = cardata["Operator"] as? [String]{
                people = op
            }
            people.append(owner)
            var role :[String:Any?] = [:]
            role["owner"] = owner
            role["operator"] = people
            //upload data
            if let newRef = self.carref{
                newRef.updateData([
                    "name":name,
                    "create time":FieldValue.serverTimestamp(),
                    K.CarAtt.attibute1:hardware1,
                    K.CarAtt.attibute2:hardware2,
                    "function":carfunction,
                    K.CarAtt.attibute3:software1,
                    K.CarAtt.attibute4:software2,
                    "role":role,
                    "status": K.FStore.avaStatus
                    
                ]) { (error) in
                    if let e = error {
                        Alert.errAlert(on: self, with: "ooops", has: e.localizedDescription,to:"try again")
                    } else {
                        DispatchQueue.main.async {
                            Alert.showBasicAlert(on: self, with: "\(name)",has:"has successfully updated!",to:"backHome")
                        }
                    }
                    
                }
            }
        }
    }
}

