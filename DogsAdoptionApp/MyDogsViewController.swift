//
//  MyDogsViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 23/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class MyDogsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddDogButton))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "All Dogs", style: .done, target: self, action: #selector(self.backToHome))
    }
    
    @objc func backToHome() {
        self.performSegue(withIdentifier: "backToHome", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func tapAddDogButton(){
        self.performSegue(withIdentifier: "addDog", sender: self)
    }
}
