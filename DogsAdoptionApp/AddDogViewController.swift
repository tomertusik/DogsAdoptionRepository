//
//  AddDogViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 23/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class AddDogViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var citytext: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapDoneButton(){
        
        let name = nameText.text
        let age = ageText.text
        let city = citytext.text
        let phone = phoneText.text
        
        // check for empty fields
        if(name!.isEmpty || age!.isEmpty || city!.isEmpty || phone!.isEmpty){
            HelpFunctions.displayAlertmessage(message: "Some required fields are not filled !",controller: self)
            return;
        }
        
        navigationController?.popViewController(animated: true)
    }
}
