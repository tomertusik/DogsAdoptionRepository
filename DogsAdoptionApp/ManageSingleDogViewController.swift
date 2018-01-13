//
//  AddDogViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 23/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManageSingleDogViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var citytext: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    var isUploaded:Bool?
    var isEditMode:Bool?
    var isPictureChanged:Bool = false
    var dog: Dog?
    var isImagePicker:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isImagePicker = false;
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
        if isEditMode! && dog != nil && !isImagePicker!{
            self.nameText.text = dog?.name
            self.ageText.text = dog?.age
            self.citytext.text = dog?.city
            self.phoneText.text = dog?.phoneForContact
            self.descriptionText.text = dog?.description
            self.image.loadImageUsingCacheWithURL(urlString: (dog?.imageURL!)!, controller: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // When done button is pressed
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
        // if user is in edit mode
        if isEditMode!{
            updateDataBase(name!,age!,city!,phone!)
        }
        // if user is in add mode
        else{
            HelpFunctions.showSpinner(status: "Few more seconds and your dog is ready for adoption...")
            saveIntoDatabase(name!,age!,city!,phone!)
        }
    }
    
    // on photo uplaod press
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
    
    // init the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        isImagePicker = true
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.image.image = image
            isUploaded = true
            isPictureChanged = true
        }
        else{
            // Error message
            HelpFunctions.displayAlertmessage(message: "Error uploading", controller: self)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // save the data and image to firebase
    func saveIntoDatabase(_ name:String, _ age:String, _ city:String, _ phone:String){
        var description = self.descriptionText.text
        if description!.isEmpty{
            description = ""
        }
        Model.instance.addDog(name, age, city, phone, description!, self.image.image!){(error) in
            if error != nil{
                HelpFunctions.hideSpinner()
                HelpFunctions.displayAlertmessage(message:"Error creating a new dog ",controller: self)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // update existing data and image
    func updateDataBase(_ name:String, _ age:String, _ city:String, _ phone:String){
        if isPictureChanged{
            HelpFunctions.showSpinner(status: "Few more seconds and your dog is ready for adoption...")
        }
        let dogKey = self.dog?.key
        let imageID = self.dog?.imageID
        let imageURL = self.dog?.imageURL
        var description = self.descriptionText.text
        if description!.isEmpty{
            description = ""
        }
        let currImage = self.image.image!
        let dog = Dog(name: name, age: age, city: city, imageURL: imageURL!, description: description!, phoneForContact: phone, key: dogKey!, imageID: imageID!)
        Model.instance.updateDog(dog: dog, image: currImage, isPictureChanged: isPictureChanged){(error) in
            if error != nil{
                HelpFunctions.displayAlertmessage(message: "Error updating dog", controller: self)
            }
            else{
                self.performSegue(withIdentifier: "unwindToMydogs", sender: self)
            }
        }
    }
}
