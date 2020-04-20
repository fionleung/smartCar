//
//  OptionsViewController.swift
//  carcar
//
//  Created by Fion Liang on 3/29/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit

class OptionsViewController: UITableViewController, CustomViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myCustomView = Bundle.main.loadNibNamed("MulitChooseRow", owner: self, options: nil)?[0] as! MulitChooseRow
        myCustomView.delegate = self

        // ... do whatever else you want with this custom view, adding it to your view hierarchy
    }


    func goToNextScene() {
        performSegue(withIdentifier: "toSecond", sender: self)
    }

}
