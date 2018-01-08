//
//  RegisterViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 22/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatTextField.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        let mail = emailTextField.text
        let pass = passwordTextField.text
        let repeatPass = repeatTextField.text
        
        // check for empty fields
        if(mail!.isEmpty || pass!.isEmpty || repeatPass!.isEmpty){
            HelpFunctions.displayAlertmessage(message: "All fields are required !",controller: self)
            return;
        }
        
        // check the email
        if(!HelpFunctions.isValidEmail(testStr: mail!)){
            HelpFunctions.displayAlertmessage(message: "Email format incorrect !", controller: self)
        }
        
        // check if passwords match
        if(pass != repeatPass){
            HelpFunctions.displayAlertmessage(message: "Passwords does not match !",controller: self)
            return;
        }
        
        HelpFunctions.showSpinner(status: "Creating user")
        
        Auth.auth().createUser(withEmail: mail!, password: pass!) { (user, error) in
            if(user == nil && error != nil){
                HelpFunctions.displayAlertmessage(message: (error?.localizedDescription)!,controller: self)
                return
            }
            else{
                self.registrationDone()
            }
        }
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // registration done
    func registrationDone(){
        HelpFunctions.hideSpinner()
        let alert = UIAlertController(title:"Registration Succeeded \nThank you", message:"", preferredStyle:UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title:"Ok",style:UIAlertActionStyle.default){
            action in
            HelpFunctions.showSpinner(status: "")
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        self.present(alert,animated: true,completion: nil)
    }
}
