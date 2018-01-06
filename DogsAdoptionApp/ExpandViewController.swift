//
//  ExpandViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 16/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ExpandViewController: UIViewController {
    
    var dog: Dog?

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogAge: UILabel!
    @IBOutlet weak var dogCity: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var dogDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dogImage.image = UIImage(named:dog!.imageName!)
        dogName.text = dog!.name!
        dogAge.text = dogAge.text! + dog!.age!
        dogCity.text = dogCity.text! + dog!.city!
        contactPhone.text = contactPhone.text! + dog!.phoneForContact!
        dogDescription.text = dog!.description!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
