//
//  Dog.swift
//  DogsAdoptionApp
//
//  Created by admin on 16/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

class Dog{
    
    var name : String?
    var age : String?
    var city : String?
    var imageName : String?
    var description :String?
    var phoneForContact : String?
    
    init(name:String, age:String, city:String, imageName:String, description :String, phoneForContact : String) {
        self.name = name;
        self.age = age
        self.city = city
        self.imageName = imageName
        self.description = description
        self.phoneForContact = phoneForContact
    }
}
