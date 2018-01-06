//
//  Extensions.swift
//  DogsAdoptionApp
//
//  Created by admin on 06/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingCacheWithURL(urlString:String, controller:UIViewController){
        self.image = nil
        
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        // otherwise make a new download for the image
        let url = URL(string:urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data,response,error) in
            if error != nil{
                HelpFunctions.displayAlertmessage(message: "Error loading image", controller: controller)
            }
            DispatchQueue.main.async{
                if let downloadedImage = UIImage(data:data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }).resume()
    }    
}
