//
//  LoginViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 22/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mail.delegate = self;
        self.pass.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    
    @IBAction func registerPressed(_ sender: Any) {
        cleanfields()
        self.performSegue(withIdentifier: "registerView", sender: self)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let email = mail.text
        let password = pass.text
        
        // check for empty fields
        if(email!.isEmpty || password!.isEmpty){
            HelpFunctions.displayAlertmessage(message: "All fields are required !",controller: self)
            return;
        }
        
        if(!HelpFunctions.isValidEmail(testStr: email!)){
            HelpFunctions.displayAlertmessage(message: "Email format is incorrect !",controller: self)
            return;
        }
        
        Auth.auth().signInAndRetrieveData(withEmail: email!, password: password!){ (user, error) in
            if(error != nil){
                HelpFunctions.displayAlertmessage(message: (error?.localizedDescription)!,controller: self)
                return;
            }
            else{
                self.cleanfields()
                self.performSegue(withIdentifier: "loginToMyDogs", sender: self)
            }
        }
    }
    
    func cleanfields(){
        self.mail.text = nil
        self.pass.text = nil
    }
}
