//
//  TaskDetailViewController.swift
//  carcar
//
//  Created by Fion Liang on 4/10/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Firebase


class TaskDetailViewController: UITableViewController {
    
    var taskRef :DocumentReference? = nil
    var detail : taskDetail? = nil
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getdata()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message:nil , preferredStyle: .actionSheet)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alert.addAction(UIAlertAction(title: "Cancel Task", style:.default, handler: {(_) in
            Alert.deletetaskAlert(on: self, taskname: self.detail!.name, delete: self.taskRef!)
            
        }))
        alert.view.tintColor = UIColor(named:"gold-1")
        self.present(alert, animated: false )
       }
    
    
    func getdata(){
          if  self.taskRef != nil {
                    let ref = self.taskRef!
                    ref.getDocument { (document, error) in
                        if let document = document, document.exists {
                            if let doc = document.data() {
                                self.detail = taskDetail(doc:doc)
                                if self.detail?.status != K.FStore.schStatus  {
                                   if let button = self.navigationItem.rightBarButtonItem {
                                        button.isEnabled = false
                                        button.tintColor = UIColor.clear
                                    }
                                }
                           
                                DispatchQueue.main.async {
                                 
                                    self.tableView.reloadData()
                                }
                            }
                            } else {
                            Alert.errAlert(on: self, with: "ooops", has: "We can't find this task now", to:"Try again")
                            }
                        }
                        
                    }
 
                    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
       let  cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
                 
                switch indexPath.row{
                case 0: cell.textLabel?.text = "Car"
                cell.detailTextLabel?.text = self.detail?.car
                case 1: cell.textLabel?.text = "Status"
                cell.detailTextLabel?.text = self.detail?.status
                case 2:cell.textLabel?.text = "Task Owner"
                cell.detailTextLabel?.text = self.detail?.owner
                case 3:cell.textLabel?.text = "Task Type"
                cell.detailTextLabel?.text = self.detail?.tasktype
                case 4:cell.textLabel?.text = "Destination"
                cell.detailTextLabel?.text = self.detail?.destination
                case 5:cell.textLabel?.text = "Time to start"
                cell.detailTextLabel?.text = self.detail?.starttime
                    case 6:cell.textLabel?.text = "Time to finish"
                    cell.detailTextLabel?.text = self.detail?.finishtime
                default: break
                }
         return cell
     }
    
     override func numberOfSections(in tableView: UITableView) -> Int {
          1
      }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
            let myLabel = UILabel()
            myLabel.frame = CGRect(x: 20, y: 0, width: 320, height: 65)
            myLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .light)
            myLabel.textColor = UIColor(named:"gold-2")
            myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

            let headerView = UIView()
            headerView.addSubview(myLabel)

            return headerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.detail?.name
       }
}
