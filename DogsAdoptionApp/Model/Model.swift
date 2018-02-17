//
//  Model.swift
//  DogsAdoptionApp
//
//  Created by admin on 12/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class Model{
    static let instance = Model()
    
    lazy private var modelSql:ModelSql? = ModelSql()
    lazy private var modelFirebase:FireBaseModel? = FireBaseModel()
    
    private init(){
    }
    
    // login
    func login(_ email:String, _ password:String, completionBlock:@escaping (Error?)->Void){
        modelFirebase?.login(email, password){ (error) in
            completionBlock(error)
        }
    }
    
    // register
    func register(_ email:String, _ password:String, completionBlock:@escaping (Error?)->Void){
        modelFirebase?.register(email, password, completionBlock: { (error) in
            completionBlock(error)
        })
    }

    // add a dog
    func addDog(_ name:String, _ age:String, _ city:String, _ phone:String,_ description:String,_ image:UIImage, completionBlock:@escaping (Error?)->Void){
        modelFirebase?.addDog(name, age, city, phone, description, image){ (error) in
            completionBlock(error)
        }
    }
    
    // update a dog
    func updateDog(dog:Dog,image:UIImage,isPictureChanged:Bool, completionBlock:@escaping (Error?)->Void){
        modelFirebase?.updateDog(dog: dog, image: image, isPictureChanged: isPictureChanged){ (error) in
            completionBlock(error)
        }
    }
    
    // delete a dog
    func deleteDog(dog:Dog, completionBlock:@escaping (Error?)->Void){
        modelFirebase?.deleteDog(dog: dog){ (error) in
            self.modelSql?.deleteDogFromLocalDb(dog: dog)
            completionBlock(error)
        }
    }
    
    // get "My Dogs"
    func getMyDogs(completionBlock:@escaping ([Dog]?)->Void){
        modelFirebase?.getMyDogs(completionBlock: { (dogs) in
            completionBlock(dogs)
        })
    }
    
    // get all dogs
    func getAllDogs(completionBlock:@escaping ([Dog]?)->Void){
        
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: modelSql?.database, table: Dog.DOGS_TABLE)
        
        // get all updated records from firebase
        modelFirebase?.getAllDogs(lastUpdateDate,completionBlock: { (dogs) in
            //update the local db
            var lastUpdate:Date?
            for dog in dogs!{
                self.modelSql?.addDogToLocalDb(dog: dog)
                if lastUpdate == nil{
                    lastUpdate = dog.lastUpdate
                }else{
                    if lastUpdate!.compare(dog.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = dog.lastUpdate
                    }
                }
            }
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.modelSql!.database, table: Dog.DOGS_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = self.modelSql?.getAllDogsFromLocalDb()
            
            //return the list to the caller
            completionBlock(totalList)
        })
    }
    
    // get image from db
    func getImage(urlString:String, completionBlock:@escaping (UIImage?)->Void){
        modelFirebase?.getImage(urlString: urlString, completionBlock: { (image) in
            completionBlock(image)
        })
    }
}
