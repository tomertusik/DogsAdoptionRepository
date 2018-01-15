//
//  Dog.swift
//  DogsAdoptionApp
//
//  Created by admin on 16/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class Dog{
    
    var name : String?
    var age : String?
    var city : String?
    var description :String?
    var phoneForContact : String?
    var imageURL : String?
    var imageID:String?
    var key:String?
    var lastUpdate:Date?
    
    init(name:String, age:String, city:String, imageURL:String, description :String, phoneForContact : String, key:String,imageID:String) {
        self.name = name;
        self.age = age
        self.city = city
        self.imageURL = imageURL
        self.description = description
        self.phoneForContact = phoneForContact
        self.key = key
        self.imageID = imageID;
    }
    
    init(dogObject:Dictionary<String,Any>){
        name = dogObject["name"] as? String
        age = dogObject["age"] as? String
        city = dogObject["city"] as? String
        phoneForContact = dogObject["phone"] as? String
        description = dogObject["description"] as? String
        key = dogObject["key"] as? String
        imageID = dogObject["imageID"] as? String
        imageURL = dogObject["imageURL"] as? String
        if let im = dogObject["imageURL"] as? String{
            imageURL = im
        }
        if let ts = dogObject["lastUpdate"] as? Double{
            self.lastUpdate = Date.fromFirebase(ts)
        }
    }
}
