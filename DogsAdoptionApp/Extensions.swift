//
//  Extensions.swift
//  DogsAdoptionApp
//
//  Created by admin on 06/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

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
