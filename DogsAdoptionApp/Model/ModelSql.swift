//
//  ModelSql.swift
//  TestFb
//
//  Created by Eliav Menachi on 21/12/2016.
//  Copyright © 2016 menachi. All rights reserved.
//

import Foundation
import SQLite3

class ModelSql{
    var database: OpaquePointer? = nil
    
    init?(){
        let dbFileName = "database9.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)

            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return nil
            }
            
//            var errormsg: UnsafeMutablePointer<Int8>? = nil
//            sqlite3_exec(database, "DROP TABLE " + Dog.DOGS_TABLE , nil, nil, &errormsg);
            
        }
        if Dog.createTable(database: database) == false{
            return nil
        }
        if LastUpdateTable.createTable(database: database) == false{
            return nil
        }
    }
    
    func addDogToLocalDb(dog:Dog){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Dog.DOGS_TABLE
            + "(" + Dog.DOG_KEY + ","
            + Dog.DOG_NAME + ","
            + Dog.DOG_AGE + ","
            + Dog.DOG_CITY + ","
            + Dog.DOG_DESCRIPTION + ","
            + Dog.DOG_PHONE + ","
            + Dog.DOG_IMAGE_URL + ","
            + Dog.DOG_IMAGE_ID + ","
            + Dog.DOGS_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let key = dog.key?.cString(using: .utf8)
            let name = dog.name?.cString(using: .utf8)
            let age = dog.age?.cString(using: .utf8)
            let city = dog.city?.cString(using: .utf8)
            let description = dog.description?.cString(using: .utf8)
            let phone = dog.phoneForContact?.cString(using: .utf8)
            let imageID = dog.imageID?.cString(using: .utf8)
            var imageUrl = "".cString(using: .utf8)
            if dog.imageURL != nil {
                imageUrl = dog.imageURL!.cString(using: .utf8)
            }
            
            sqlite3_bind_text(sqlite3_stmt, 1, key,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, name,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, age,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, city,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, description,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, phone,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, imageID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 8, imageUrl,-1,nil);
            
            if (dog.lastUpdate == nil){
                dog.lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 9, dog.lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    
    func getAllDogsFromLocalDb()->[Dog]{
        var dogs = [Dog]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from DOGS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let key =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let name =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let age =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let city =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let description =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
                let phone =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,5))
                let imageID =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                var imageUrl =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,7))
                if (imageUrl != nil && imageUrl == ""){
                    imageUrl = nil
                }
                let dog = Dog(name: name!, age: age!, city: city!, imageURL: imageUrl!, description: description!, phoneForContact: phone!, key: key!, imageID: imageID!)
                dogs.append(dog)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return dogs
    }
    
    
    func deleteDogFromLocalDb(dog:Dog){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"delete from " +
            Dog.DOGS_TABLE + " where " +
            Dog.DOG_KEY + " = ?;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, dog.key?.cString(using: .utf8),-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) != SQLITE_DONE){
                print ("failes executing deleteStudent")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
}























