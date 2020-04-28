//
//  MenuViewController.swift
//  carcar
//
//  Created by Fion Liang on 3/27/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UITableViewController{
    
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
           super.viewDidLoad()
            
        self.userName.text = Auth.auth().currentUser?.email
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [2,1]{
            Alert.logoutAlert(on: self)
      }
    }
    
    
}
