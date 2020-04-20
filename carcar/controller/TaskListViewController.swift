//
//  TaskListViewController.swift
//  carcar
//
//  Created by Fion Liang on 4/11/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Firebase


class TaskListViewController: UITableViewController {
    
   let db = Firestore.firestore()
   var tasks : [[taskSum]] = [[],[],[],[]]
   let sectionHeader : [String] = ["Tasks in process ","Tasks scheduled", "Tasks finished","Tasks cancelled"] //todo:cancell task
    var ref: [[DocumentReference]] = [[],[],[],[]]
    var selected:DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
    }
   
    func getdata(){
        ref =  [[],[],[],[]]
        tasks  = [[],[],[],[]]
        if  let owner = Auth.auth().currentUser?.email {
            let query = db.collectionGroup(K.FStore.taskList).whereField("owner", isEqualTo: owner)
            query.getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            let newtask = taskSum(doc:data)
                            if newtask.status == "working" {
                                self.tasks[0].append(newtask)
                                self.ref[0].append(doc.reference)
                            } else if newtask.status == "scheduled" {
                                self.tasks[1].append(newtask)
                                self.ref[1].append(doc.reference)
                            }else  if newtask.status == "finished"{
                                self.tasks[2].append(newtask)
                                self.ref[2].append(doc.reference)
                            }
                            else  {
                                self.tasks[3].append(newtask)
                                self.ref[3].append(doc.reference)
                            }
                            DispatchQueue.main.async {
                               self.tableView.reloadData()
//                                print(data)
                                
                            }
                        }
                    }
                }
            }
        }
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "seeDetail" {
             let destinationVC = segue.destination as! TaskDetailViewController
             destinationVC.taskRef = self.selected

         }
     }
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              self.selected = self.ref[indexPath.section][indexPath.row]
             performSegue(withIdentifier: "seeDetail", sender: self)
         }


     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tasks[section].count
     }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let task = tasks[indexPath.section][indexPath.row]
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        cell.textLabel?.text = task.taskname
        cell.detailTextLabel?.text = task.detail
         cell.accessoryType = .disclosureIndicator
         cell.accessoryView = UIImageView(image: UIImage(named: "arrow"))
         return cell
     }
     
     override func numberOfSections(in tableView: UITableView) -> Int {
        tasks.count
         
     }
     
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return sectionHeader[section]
     }
     
     
}
