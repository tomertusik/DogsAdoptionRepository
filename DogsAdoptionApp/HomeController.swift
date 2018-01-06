//
//  ViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 16/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dogsTableView: UITableView!
    var dogs : Array<Dog> = Array()
    var selectedIndex = Int()
    var isLoggedIn:User?

    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Dogs", style: .done, target: self, action: #selector(tapMyDogsButton))
        
        let dataBaseRef = Database.database().reference()
        
        dataBaseRef.child("Users").observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.dogs.removeAll()
                for user in snapshot.children.allObjects as! [DataSnapshot]{
                    if user.childrenCount > 0{
                        for dogs in user.children.allObjects as! [DataSnapshot]{
                            for dog in dogs.children.allObjects as! [DataSnapshot]{
                                let dogObject = dog.value as? [String:String]
                                let name = dogObject?["name"]
                                let age = dogObject?["age"]
                                let city = dogObject?["city"]
                                let phone = dogObject?["phone"]
                                let description = dogObject?["description"]
                                
                                if let imageURL = dogObject?["imageURL"]{
                                    let dog = Dog(name: name!, age: age!, city: city!, imageURL: imageURL, description: description!, phoneForContact: phone!)
                                    self.dogs.append(dog)
                                }
                            }
                        }
                    }
                }
                self.dogsTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        }
        else{
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            HelpFunctions.displayAlertmessage(message: signOutError.description, controller: self)
        }
        self.navigationItem.leftBarButtonItem = nil
        HelpFunctions.displayAlertmessage(message: "Logged out successfully!", controller: self)
    }
    
    @objc func tapMyDogsButton(){
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "myDogs", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogCellTableViewCell
        cell.dogName.text = dogs[indexPath.row].name
        cell.dogAge.text = dogs[indexPath.row].age
        cell.dogCity.text = dogs[indexPath.row].city
        cell.dogImage.loadImageUsingCacheWithURL(urlString: dogs[indexPath.row].imageURL!, controller: self)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "expand", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "expand"){
            let expandController:ExpandViewController = segue.destination as! ExpandViewController
            expandController.dog = dogs[selectedIndex]
        }
    }
}

