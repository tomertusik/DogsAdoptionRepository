//
//  FireBaseModel.swift
//  DogsAdoptionApp
//
//  Created by admin on 12/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase

class FireBaseModel{
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    // login
    func login(_ email:String, _ password:String, completionBlock:@escaping (Error?)->Void){
        Auth.auth().signInAndRetrieveData(withEmail: email, password: password){ (user, error) in
            completionBlock(error)
        }
    }
    
    // register
    func register(_ email:String, _ password:String, completionBlock:@escaping (Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            completionBlock(error)
        }
    }
    
    // add a dog to data base
    func addDog(_ name:String, _ age:String, _ city:String, _ phone:String,_ description:String,_ image:UIImage, completionBlock:@escaping (Error?)->Void){
        let dataBaseRef = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs").childByAutoId()
        let imageID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs Images").child(imageID)
        if let dogImageData = UIImagePNGRepresentation(image){
            storageRef.putData(dogImageData, metadata: nil, completion:
                {(metadata,error) in
                    if let imageURL = metadata?.downloadURL()?.absoluteString{
                        let key = dataBaseRef.key
                        let lastUpdate = ServerValue.timestamp()
                        let dog = ["name":name, "age":age, "city":city, "phone":phone, "description":description,"imageURL":imageURL, "key":key,"imageID":imageID, "lastUpdate":lastUpdate] as [String : Any]
                        dataBaseRef.setValue(dog)
                    }
                    completionBlock(error)
            })
        }
    }
    
    // update a dog in data base
    func updateDog(dog:Dog,image:UIImage,isPictureChanged:Bool, completionBlock:@escaping (Error?)->Void){
        let dataBaseRef = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs").child(dog.key!)
        if isPictureChanged{
            // change the imageURL and save new picture to storage
            let storageRef = Storage.storage().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs Images").child(dog.imageID!)
            // Delete the file
            storageRef.delete { error in
                if error != nil {
                    completionBlock(error)
                }
            }
            if let dogImageData = UIImagePNGRepresentation(image){
                storageRef.putData(dogImageData, metadata: nil, completion:
                    {(metadata,error) in
                        if error != nil {
                            completionBlock(error)
                        }
                        if let imageURL = metadata?.downloadURL()?.absoluteString{
                            self.updateData(dog.name!, dog.age!, dog.city!, dog.phoneForContact!, dog.description!, imageURL, dog.key!, dog.imageID!, dataBaseRef, completionBlock: {(error) in
                                completionBlock(error)
                            })
                        }
                })
            }
        }
        else{
            self.updateData(dog.name!, dog.age!, dog.city!, dog.phoneForContact!, dog.description!, dog.imageURL!, dog.key!, dog.imageID!, dataBaseRef, completionBlock: {(error) in
                completionBlock(error)
            })
        }
    }
    
    // update data in firebase
    private func updateData(_ name:String, _ age:String, _ city:String, _ phone:String, _ description:String, _ imageURL:String, _ dogKey:String, _ imageID:String,_ dataBaseRef:DatabaseReference, completionBlock:@escaping (Error?)->Void){
        let dog = ["name":name, "age":age, "city":city, "phone":phone, "description":description,"imageURL":imageURL, "key":dogKey,"imageID":imageID]
        dataBaseRef.updateChildValues(dog as Any as! [AnyHashable : Any], withCompletionBlock: {(error,dataBaseRef) in
            completionBlock(error)
        })
    }
    
    // delete a dog from data base
    func deleteDog(dog:Dog, completionBlock:@escaping (Error?)->Void){
        let dataBaseRef = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs").child((dog.key)!)
        let storageRef = Storage.storage().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs Images").child((dog.imageID)!)
        // Delete the file
        storageRef.delete { error in
            if error != nil {
                completionBlock(error)
            }
        }
        dataBaseRef.removeValue(completionBlock: { (error,dataBaseRef) in
                completionBlock(error)
        })
    }
    
    // get "My dogs"
    func getMyDogs(completionBlock:@escaping ([Dog]?)->Void){
        let dataBaseRef = Database.database().reference()
        var dogsList = [Dog]()
        dataBaseRef.child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs").observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                dogsList.removeAll()
                for dog in snapshot.children.allObjects as! [DataSnapshot]{
                    let dogInfo = self.getDogInfo(dog: dog)
                    dogsList.append(dogInfo)
                }
                completionBlock(dogsList)
            }
            else{
                completionBlock(nil)
            }
        })
    }
    
    // get all dogs
    func getAllDogs(_ lastUpdateDate:Date? ,completionBlock:@escaping ([Dog]?)->Void){
        let dataBaseRef = Database.database().reference()
        var dogsList = [Dog]()
        dataBaseRef.child("Users").observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                dogsList.removeAll()
                for user in snapshot.children.allObjects as! [DataSnapshot]{
                    if user.childrenCount > 0{
                        for dogs in user.children.allObjects as! [DataSnapshot]{
                            for dog in dogs.children.allObjects as! [DataSnapshot]{
                                let dogInfo = self.getDogInfo(dog: dog)
                                dogsList.append(dogInfo)
                            }
                        }
                    }
                }
                completionBlock(dogsList)
            }
            else{
                completionBlock(nil)
            }
        })
    }
    
    // get dog information from snapshot
    private func getDogInfo(dog:DataSnapshot)->Dog{
        let dogobject = dog.value as? Dictionary<String,Any>
        let dogInfo = Dog(dogObject: dogobject!)
        return dogInfo
    }

    // get image from data base
    func getImage(urlString:String, completionBlock:@escaping (UIImage?)->Void){
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            completionBlock(cachedImage)
        }
        else{
            // otherwise make a new download for the image
            let url = URL(string:urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: {(data,response,error) in
                if error != nil{
                    completionBlock(nil)
                }
                DispatchQueue.main.async{
                    if let downloadedImage = UIImage(data:data!){
                        self.imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        completionBlock(downloadedImage)
                    }
                }
            }).resume()
        }
    }
}
