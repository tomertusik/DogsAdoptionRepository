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
            let editButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEditDogButton))
            let deletebutton:UIBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(tapDeleteButton))
            self.navigationItem.rightBarButtonItems = [editButton,deletebutton]
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
    
    override func viewDidAppear(_ animated: Bool) {
        HelpFunctions.hideSpinner()
    }
    
    // delete button is pressed
    @objc func tapDeleteButton(){
        displaySureMessage()
    }
    
    func displaySureMessage(){
        let alert = UIAlertController(title:"Are you sure?", message:"",preferredStyle:UIAlertControllerStyle.alert)
        let no = UIAlertAction(title:"No",style:UIAlertActionStyle.default,handler:nil)
        let yes = UIAlertAction(title:"Yes",style:UIAlertActionStyle.default,handler:{(alert: UIAlertAction!) in
            HelpFunctions.showSpinner(status: "Removing your dog...")
            Model.instance.deleteDog(dog: self.dog!){(error) in
                if error != nil{
                    HelpFunctions.hideSpinner()
                    HelpFunctions.displayAlertmessage(message:"Error deleting the dog ",controller: self)
                    return
                }
                else{
                    self.performSegue(withIdentifier: "unwindToMyDogs", sender: self)
                }
            }
        })
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert,animated: true,completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapEditDogButton(){
        HelpFunctions.showSpinner(status: "Loading...")
        performSegue(withIdentifier: "editMode", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editMode"){
            let editController:ManageSingleDogViewController = segue.destination as! ManageSingleDogViewController
            editController.dog = dog
            editController.isEditMode = true
            editController.isUploaded = true
        }
        else if segue.identifier == "unwindToMyDogs"{
            let dogsController:MyDogsViewController = segue.destination as! MyDogsViewController
            dogsController.hideSpinner = true
        }
    }
}
