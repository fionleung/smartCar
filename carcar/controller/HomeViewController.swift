//
//  HomeViewController.swift
//  carcar
//
//  Created by Fion Liang on 3/27/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UITableViewController{
    
    
//    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
    var cars : [[CarList]] = [[],[],[],[]]
    let sectionHeader : [String] = ["Working Cars","Scheduled Cars", "Available Cars","Disabled Cars"]
    var selectedCar : DocumentReference? = nil
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        title = "Your Cars"
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: "labelcell")
        tableView.dataSource = self

        //todo:scoll down to reload
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            getdata()
        
    }
    
    func getdata(){
        self.cars = [[],[],[],[]]
        if  let owner = Auth.auth().currentUser?.email {
            let ref = self.db.collection(K.FStore.carCollection)
            let query = ref.whereField(K.FStore.people, arrayContains: owner)
           let query1 = query.whereField("status", isEqualTo: K.FStore.avaStatus)
            query1.getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let name = data["name"] as? String,
                                let function = data["function"] as? [String:Int] {
                                let newcar = CarList(carname: name, carref: doc.reference, fun: function)
                                self.cars[2].append(newcar)
                             
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        }
                    }
                }
            }
            let query2 = query.whereField("status", isEqualTo: K.FStore.schStatus)
            query2.getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let name = data["name"] as? String,
                                let time = data["scheduletime"] as? Timestamp {
                                let newcar = CarList(carname: name, carref: doc.reference, time:time)
                                self.cars[1].append(newcar)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        }
                    }
                }
            }
            let query3 = query.whereField("status", isEqualTo: K.FStore.busyStatus)
                       query3.getDocuments(){ (querySnapshot, err) in
                           if let err = err {
                               print("Error getting documents: \(err)")
                           } else {
                               if let snapshotDocuments = querySnapshot?.documents {
                                   for doc in snapshotDocuments {
                                       let data = doc.data()
                                    if let name = data["name"] as? String,
                                           let time = data["scheduletime"] as? Timestamp {
                                        let newcar = CarList(carname: name, carref: doc.reference, time:time)
                                           self.cars[0].append(newcar)
                                           DispatchQueue.main.async {
                                               self.tableView.reloadData()
                                               
                                           }
                                       }
                                   }
                               }
                           }
                       }
            let query4 = query.whereField("status", isEqualTo: K.FStore.cardisable)
            query4.getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                         if let name = data["name"] as? String
                                {
                             let newcar = CarList(carname: name, carref: doc.reference, time: nil)
                                self.cars[3].append(newcar)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            let destinationVC = segue.destination as! CarDetailViewController
            destinationVC.carref = self.selectedCar
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             self.selectedCar = self.cars[indexPath.section][indexPath.row].carRef
             performSegue(withIdentifier: "goDetail", sender: self)
        }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars[section].count
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let car = cars[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
        cell.textLabel?.text = car.carName
        if indexPath.section == 1 {
            cell.detailTextLabel?.text = "Schedule task on : " + car.details
        } else if indexPath.section == 2 {
            cell.detailTextLabel?.text = car.details
        } else if indexPath.section == 0{
             cell.detailTextLabel?.text = "Task started at : " + car.details
        }
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: UIImage(named: "arrow"))
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        self.cars.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    

    
  
    
   
    
}
