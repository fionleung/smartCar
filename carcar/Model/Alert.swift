//
//  Alert.swift
//  carcar
//
//  Created by Fion Liang on 4/13/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Firebase

struct Alert {
    static func showBasicAlert(on vc: UIViewController, with title: String,has message: String, to segue: String){
        let alert = UIAlertController(title: title, message:message , preferredStyle: .alert)
       
       
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alert.view.tintColor = UIColor.white
       
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.last?.backgroundColor = UIColor(named:"gold-1")
        
        alert.setValue(NSAttributedString(string: "\n" + title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .light),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: "\n" + message + "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .light),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
            vc.performSegue(withIdentifier: segue, sender: self)
         }))
        vc.present(alert,animated: false)
    }
    
    static func errAlert(on vc: UIViewController, with title: String,has message: String,to button:String){
        let alert = UIAlertController(title: title, message:message , preferredStyle: .alert)
       
       
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alert.view.tintColor = UIColor.white
       
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.last?.backgroundColor = UIColor(named:"gold-1")
        
        alert.setValue(NSAttributedString(string: "\n" + title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .thin),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: "\n" + message + "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .thin),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
         alert.addAction(UIAlertAction(title: button, style: .default, handler: nil))
        vc.present(alert,animated: false)
    }
    

    static func logoutAlert(on vc: UIViewController){
        vc.viewWillAppear(false)
        let alert = UIAlertController(title: "Are you going to logout?", message:"" , preferredStyle: .alert)

        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alert.view.tintColor = UIColor.white
     
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.last?.backgroundColor = UIColor(named:"gold-1")
        alert.setValue(NSAttributedString(string: "\n" + "Are you going to logout? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .thin),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: {(_) in
            do {
                try Auth.auth().signOut()
                vc.performSegue(withIdentifier: "logout", sender: nil)
            } catch let signOutError as NSError {
                errAlert(on: vc, with: "oooops", has: signOutError.localizedDescription,to:"Try again")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        vc.present(alert,animated: false)
    }
    
    static func deletetaskAlert(on vc: UIViewController, taskname: String,delete ref: DocumentReference){
           let alert = UIAlertController(title: "Are you going to logout?", message:"" , preferredStyle: .alert)

           alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
           alert.view.tintColor = UIColor.white
        
           alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.last?.backgroundColor = UIColor(named:"gold-1")
           alert.setValue(NSAttributedString(string: "\n" + "Are you sure to cancel this task? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .thin),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
           alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(_) in
            //update taskdetail
            ref.updateData([
                "status": K.FStore.cancelStatus,
               ]){ (error) in
                   if let e = error {
                    Alert.errAlert(on: vc, with: "ooops", has: e.localizedDescription,to: "Try again")
                   }
           }
            //update car
            if let carref = ref.parent.parent{
                carref.updateData([
                     "status": K.FStore.avaStatus,
                    ]){ (error) in
                        if let e = error {
                            Alert.errAlert(on: vc, with: "ooops", has: e.localizedDescription,to:"Try again")
                        } else {
                            DispatchQueue.main.async {
                                
                                Alert.errAlert(on: vc, with: taskname, has: "was successfully cancelled", to: "OK")
                                vc.viewWillAppear(false)
                            }
                            
                        }
                }
            }

           }))
           alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
           vc.present(alert,animated: false)
    }
    
    static func deletetcarAlert(on vc: UIViewController, carname: String,delete ref: DocumentReference){
           let alert = UIAlertController(title: "Are you going to logout?", message:"" , preferredStyle: .alert)

           alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
           alert.view.tintColor = UIColor.white
        
           alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.last?.backgroundColor = UIColor(named:"gold-1")
           alert.setValue(NSAttributedString(string: "\n" + "Are you sure to disable \(carname)? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .thin),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
           alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(_) in
            //update taskdetail
            ref.updateData([
                "status": K.FStore.cardisable,
               ]){ (error) in
                   if let e = error {
                    Alert.errAlert(on: vc, with: "ooops", has: e.localizedDescription,to: "Try again")
                   }
                else {
                    DispatchQueue.main.async {
                        Alert.errAlert(on: vc, with: carname, has: "was successfully disable", to: "OK")
                        vc.viewWillAppear(false)
                    }
                }
           }

           }))
           alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
           vc.present(alert,animated: false)
    }

}

