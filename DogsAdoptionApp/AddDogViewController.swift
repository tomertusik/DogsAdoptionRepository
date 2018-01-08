//
//  AddDogViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 23/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class AddDogViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var citytext: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    var isUploaded:Bool?
    var isEditMode:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.nameText.delegate = self
        self.ageText.delegate = self
        self.citytext.delegate = self
        self.phoneText.delegate = self
        self.descriptionText.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        HelpFunctions.hideSpinner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
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
        
        // check if image is not uploaded
        if(!isUploaded!){
            HelpFunctions.displayAlertmessage(message: "Please upload a photo", controller: self)
            return
        }
        HelpFunctions.showSpinner(status: "Few more seconds and your dog is reay for adoption...")
        saveIntoDatabase(name!,age!,city!,phone!)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func UploadPhoto(_ sender: Any) {
        HelpFunctions.showSpinner(status: "Loading")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true){
            HelpFunctions.hideSpinner()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.image.image = image
            isUploaded = true
        }
        else{
            // Error message
            HelpFunctions.displayAlertmessage(message: "Error uploading", controller: self)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveIntoDatabase(_ name:String, _ age:String, _ city:String, _ phone:String){
        let dataBaseRef = Database.database().reference()
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs Images").child(imageName)
        
        var description = self.descriptionText.text
        if description!.isEmpty{
            description = ""
        }
        
        if let dogImageData = UIImagePNGRepresentation(self.image.image!){
            storageRef.putData(dogImageData, metadata: nil, completion:
                {(metadata,error) in
                    if error != nil {
                        HelpFunctions.displayAlertmessage(message: "Error saving image", controller: self)
                        return
                    }
                    if let imageURL = metadata?.downloadURL()?.absoluteString{
                        let dog = ["name":name, "age":age, "city":city, "phone":phone, "description":description,"imageURL":imageURL]
                        dataBaseRef.child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs").childByAutoId().setValue(dog)
                    }
            })
        }
    }
    
}
