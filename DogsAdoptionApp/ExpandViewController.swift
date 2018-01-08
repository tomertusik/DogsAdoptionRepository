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
    var isInMyDogs:Bool?

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogAge: UILabel!
    @IBOutlet weak var dogCity: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var dogDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isInMyDogs!{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEditDogButton))
        }
        dogImage.layer.cornerRadius = dogImage.frame.size.width/2
        dogImage.clipsToBounds = true
        dogImage.loadImageUsingCacheWithURL(urlString: dog!.imageURL!, controller: self)
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
    
    @objc func tapEditDogButton(){
        performSegue(withIdentifier: "editMode", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editMode"){
            let editController:AddDogViewController = segue.destination as! AddDogViewController
            editController.isEditMode = true
            editController.isUploaded = true
        }
    }
}
