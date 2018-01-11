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
            performSegue(withIdentifier: "unwindToMydogs", sender: self)
        }
        // if user is in add mode
        else{
            HelpFunctions.showSpinner(status: "Few more seconds and your dog is ready for adoption...")
            saveIntoDatabase(name!,age!,city!,phone!)
            navigationController?.popViewController(animated: true)
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
        let dataBaseRef = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs").childByAutoId()
        let imageID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs Images").child(imageID)
        
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
                        let key = dataBaseRef.key
                        let dog = ["name":name, "age":age, "city":city, "phone":phone, "description":description,"imageURL":imageURL, "key":key,"imageID":imageID]
                        dataBaseRef.setValue(dog)
                    }
            })
        }
    }
    
    // update existing data and image
    func updateDataBase(_ name:String, _ age:String, _ city:String, _ phone:String){
        let dogKey = self.dog?.key
        let imageID = self.dog?.imageID
        let dataBaseRef = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs").child(dogKey!)
        var description = self.descriptionText.text
        if description!.isEmpty{
            description = ""
        }
        if isPictureChanged{
            HelpFunctions.showSpinner(status: "Few more seconds and your dog is ready for adoption...")
            // change the imageURL and save new picture to storage
            let storageRef = Storage.storage().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs Images").child(imageID!)
            // Delete the file
            storageRef.delete { error in
                if error != nil {
                    HelpFunctions.displayAlertmessage(message: "Error", controller: self)
                    return
                }
            }
            if let dogImageData = UIImagePNGRepresentation(self.image.image!){
                storageRef.putData(dogImageData, metadata: nil, completion:
                    {(metadata,error) in
                        if error != nil {
                            HelpFunctions.displayAlertmessage(message: "Error saving image", controller: self)
                            return
                        }
                        if let imageURL = metadata?.downloadURL()?.absoluteString{
                            self.updateData(name, age, city, phone, description!, imageURL, dogKey!, imageID!, dataBaseRef)
                        }
                })
            }
        }
        else{
            let imageURL = self.dog?.imageURL
            self.updateData(name, age, city, phone, description!, imageURL!, dogKey!, imageID!, dataBaseRef)
        }
    }
    
    // update data in firebase
    func updateData(_ name:String, _ age:String, _ city:String, _ phone:String, _ description:String, _ imageURL:String, _ dogKey:String, _ imageID:String, _ dataBaseRef:DatabaseReference){
        let dog = ["name":name, "age":age, "city":city, "phone":phone, "description":description,"imageURL":imageURL, "key":dogKey,"imageID":imageID]
        dataBaseRef.updateChildValues(dog as Any as! [AnyHashable : Any])
    }
    
}
