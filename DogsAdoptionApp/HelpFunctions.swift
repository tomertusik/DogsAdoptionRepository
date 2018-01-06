//
//  HelpFunctions.swift
//  DogsAdoptionApp
//
//  Created by admin on 22/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class HelpFunctions{
    
    // show spinner
    static func showSpinner(status:String){
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: status)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    // hide spinner
    static func hideSpinner(){
        SVProgressHUD.dismiss()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // displays alert message
    static func displayAlertmessage(message : String, controller: UIViewController){
        let alert = UIAlertController(title:message, message:"",preferredStyle:UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title:"Ok",style:UIAlertActionStyle.default,handler:nil)
        alert.addAction(ok)
        controller.present(alert,animated: true,completion: nil)
    }
    
    // check email
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

