//
//  WelcomeViewController.swift
//  carcar
//
//  Created by Fion Liang on 2/22/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor:UIColor(named:"greyBlue-2") ?? UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor(named:"greyBlue-2") ?? UIColor.lightGray])
        emailTextField.delegate=self
        passwordTextField.delegate=self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.emailTextField){
            
            passwordTextField.becomeFirstResponder()
        }
        if (textField == self.passwordTextField){
            loginSubmit()
               }
     return true
    }
    
    @IBAction func submit(_ sender: UIButton) {
      loginSubmit()
      
     
     
    }
    
    func loginSubmit(){
        if let email = emailTextField.text, let password = passwordTextField.text {
                     Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                         if let e = error {
                             print (e)
                         } else {
                             self.performSegue(withIdentifier: "LoginToHome", sender: self)
                         }
                     }
                     }
    }
    



}
