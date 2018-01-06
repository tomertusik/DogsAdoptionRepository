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
    
    init(name:String, age:String, city:String, imageURL:String, description :String, phoneForContact : String) {
        self.name = name;
        self.age = age
        self.city = city
        self.imageURL = imageURL
        self.description = description
        self.phoneForContact = phoneForContact
    }
}
