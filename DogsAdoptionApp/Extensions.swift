//
//  Extensions.swift
//  DogsAdoptionApp
//
//  Created by admin on 06/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit
import SQLite3

// UIImage capable of downloading the image from data base
extension UIImageView{
    
    func loadImageUsingCacheWithURL(urlString:String, controller:UIViewController){
        self.image = nil
        
        Model.instance.getImage(urlString: urlString, completionBlock: { (image) in
            if image != nil{
                self.image = image
                HelpFunctions.hideSpinner()
            }
            else{
                HelpFunctions.displayAlertmessage(message: "Error loading image", controller: controller)
            }
        })
    }
}

// View controllers able to show and hide loading spinner
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Make string writeable to database
extension String {
    public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
        if let (result, _) = String.decodeCString(cString, as: UTF8.self,
                                                  repairingInvalidCodeUnits: false) {
            self = result
        }
        else {
            return nil
        }
    }
}

// Set and Get update date to / from fire base
extension Date {
    
    func toFirebase()->Double{
        return self.timeIntervalSince1970 * 1000
    }
    
    static func fromFirebase(_ interval:String)->Date{
        return Date(timeIntervalSince1970: Double(interval)!)
    }
    
    static func fromFirebase(_ interval:Double)->Date{
        if (interval>9999999999){
            return Date(timeIntervalSince1970: interval/1000)
        }else{
            return Date(timeIntervalSince1970: interval)
        }
    }
    
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
}

// Abillities to creat local sqlite table
extension Dog{
    static let DOGS_TABLE = "DOGS"
    static let DOG_NAME = "NAME"
    static let DOG_AGE = "AGE"
    static let DOG_CITY = "CITY"
    static let DOG_DESCRIPTION = "DESCRIPTION"
    static let DOG_PHONE = "PHONE"
    static let DOG_IMAGE_URL = "IMAGE_URL"
    static let DOG_IMAGE_ID = "IMAGE_ID"
    static let DOG_KEY = "KEY"
    static let DOGS_LAST_UPDATE = "DOGS_LAST_UPDATE"
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + DOGS_TABLE + " ( " + DOG_KEY + " TEXT PRIMARY KEY, "
            + DOG_NAME + " TEXT, "
            + DOG_AGE + " TEXT, "
            + DOG_CITY + " TEXT, "
            + DOG_DESCRIPTION + " TEXT, "
            + DOG_PHONE + " TEXT, "
            + DOG_IMAGE_URL + " TEXT, "
            + DOG_IMAGE_ID + " TEXT, "
            + DOGS_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
}
