//
//  CarDetailViewConntrol.swift
//  carcar
//
//  Created by Fion Liang on 4/5/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Firebase


class CarDetailViewController: UITableViewController {
    //todo:edit and cancel
    
    
    let db = Firestore.firestore()
    var carref : DocumentReference? = nil
    var carInfo : [String:String] = [:]
    var functionSet = Set<String>()
    var task : [taskInfo] = []
    var people : [String] = []
    var selected : DocumentReference? = nil

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "taskListCell", bundle: nil), forCellReuseIdentifier: "taskCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         getdata()
    }
    
    func getdata(){
        if  self.carref != nil {
            let ref = self.carref!
            ref.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    if let people = data?["role"] as? [String:Any] {
                        if let owner = people["owner"] as? String{
                             if  owner != Auth.auth().currentUser?.email {
                                 if let button = self.navigationItem.rightBarButtonItem {
                                 button.isEnabled = false
                                 button.tintColor = UIColor.clear
                                                               }
                             }
                            if let others = people["operator"] as? [String]{
                                for one in others {
                                    if one != owner {
                                        self.people.append(one)
                                    }
                                }
                            }
                        }
                       
                    }
                    if let name = data?["name"] as? String,
                        let att1 = data?[K.CarAtt.attibute1] as? String,
                        let att2 = data?[K.CarAtt.attibute2] as? String,
                        let att3 = data?[K.CarAtt.attibute3] as? String,
                        let att4 = data?[K.CarAtt.attibute4] as? String,
                        let function = data?["function"] as? [String:Int],
                        let status = data?["status"] as? String
                    {
                        
                        self.carInfo["status"] = status
                        self.carInfo["name"] = name
                        self.carInfo[K.CarAtt.attibute1] = att1
                        self.carInfo[K.CarAtt.attibute2] = att2
                        self.carInfo[K.CarAtt.attibute3] = att3
                        self.carInfo[K.CarAtt.attibute4] = att4
                        var arr : [String] = []
                        for (key, value) in function {
                            if value == 1 {
                                arr.append(key)
                            }
                        }
                        self.functionSet = Set(arr)
                        self.carInfo["function"] =  arr.joined(separator: ",")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Document does not exist")
                    }
                    
                }
                
            }
            self.task = []
            ref.collection(K.FStore.taskList).order(by: "startTime",descending: true).limit(to: 10)
                .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in querySnapshot!.documents {
                        let newtask = taskInfo(doc:doc)
                        self.task.append(newtask)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                          
                                               }
                        }
                    }
                }
            }

        }
        
    
        @IBAction func editTapped(_ sender: Any) {
            let alert = UIAlertController(title: nil, message:nil , preferredStyle: .actionSheet)
            alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            alert.addAction(UIAlertAction(title: "Edit car info", style:.default, handler: {(_) in
                self.performSegue(withIdentifier: "editCar", sender: self)
                }))
    
            alert.addAction(UIAlertAction(title: "Disable car", style:.default, handler: {(_) in
                if self.carInfo["status"] == K.FStore.schStatus {
                    Alert.errAlert(on: self, with: "oooops", has: "Please cancel the scheduled task first", to: "OK")
                }
                else{
                    Alert.deletetcarAlert(on: self, carname: self.carInfo["name"] ?? "", delete: self.carref!)
                }
            }))
                               alert.view.tintColor = UIColor(named:"gold-1")
                               self.present(alert, animated: false )
                
               
        }
    
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "seeTask" {
                let destinationVC = segue.destination as! TaskDetailViewController
                destinationVC.taskRef = self.selected!
            }
            if segue.identifier == "editCar"{
                let destinationVC = segue.destination as! AddCarViewController
                destinationVC.carInfo = self.carInfo
                destinationVC.carref = self.carref
                destinationVC.editMood = true
                destinationVC.functionSet = self.functionSet
                destinationVC.people = self.people
                
            }
        }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var c = 0;
        if section == 0 {
            c=5
        }
        else {
            c = self.task.count
        }
        return c
     }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
          let  cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
                    
                   switch indexPath.row{
                   case 0: cell.textLabel?.text = K.CarAtt.attibute1
                   cell.detailTextLabel?.text = self.carInfo[K.CarAtt.attibute1]
                   case 1:cell.textLabel?.text = K.CarAtt.attibute2
                   cell.detailTextLabel?.text = self.carInfo[K.CarAtt.attibute2]
                   case 2:cell.textLabel?.text = K.CarAtt.attibute3
                   cell.detailTextLabel?.text = self.carInfo[K.CarAtt.attibute3]
                   case 3:cell.textLabel?.text = K.CarAtt.attibute4
                   cell.detailTextLabel?.text = self.carInfo[K.CarAtt.attibute4]
                   case 4:cell.textLabel?.text = "Function"
                   cell.detailTextLabel?.text = self.carInfo["function"]
                   default: break
                   }
            return cell
        }
       else  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! taskListCell
        cell.titleLabel.text = self.task[indexPath.row].name
            cell.detailLabel.text = self.task[indexPath.row].detail
            cell.statusLabel.text = self.task[indexPath.row].status

            if self.task[indexPath.row].owner == Auth.auth().currentUser?.email {
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = UIImageView(image: UIImage(named: "arrow"))
            } else {
                 cell.isUserInteractionEnabled = false
            }
        return cell
        }
     }
     
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    

    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let myLabel = UILabel()
            myLabel.frame = CGRect(x: 20, y: 0, width: 320, height: 65)
            myLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .light)
            myLabel.textColor = UIColor(named:"gold-2")
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

            let headerView = UIView()
            headerView.addSubview(myLabel)

            return headerView
        }
        else {
           let myLabel = UILabel()
            myLabel.frame = CGRect(x: 20, y: 10, width: 320, height: 30)
            myLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .light)
            myLabel.textColor = UIColor(named:"gold-2")
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

            let headerView = UIView()
            headerView.addSubview(myLabel)
            return headerView
    }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return self.carInfo["name"]}
        else {
            return "Task List"
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1
        {return 60}
        else { return 44 }
    }
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    if let ref = self.task[indexPath.row].ref as DocumentReference? {
        self.selected = ref
        performSegue(withIdentifier: "seeTask", sender: self)
    }
         
    }
}
