//
//  RegisterViewController.swift
//  carcar
//
//  Created by Fion Liang on 2/22/20.
//  Copyright © 2020 Fion Liang. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor:UIColor(named:"greyBlue-2") ?? UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor(named:"greyBlue-2") ?? UIColor.lightGray])
        emailTextField.delegate=self
        passwordTextField.delegate=self
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        loginSubmit()
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
    
    
    func loginSubmit(){
           if let email = emailTextField.text, let password = passwordTextField.text{
           Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
               if let e = error{
                   self.errorLabel.text = e.localizedDescription
                   self.errorLabel.isHidden = false
                   print(e.localizedDescription)
               } else {
                   self.performSegue(withIdentifier: "RegisterToHome", sender: self)
               }
           }
           }
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
