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
        
        HelpFunctions.showSpinner(status: "Loading dogs")
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Dogs", style: .done, target: self, action: #selector(tapMyDogsButton))
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
        ModelNotification.AllDogsList.observe { (list) in
            if (list != nil && !(list?.isEmpty)!){
                self.dogs = list!
                self.dogsTableView.reloadData()
            }
            else{
                HelpFunctions.displayAlertmessage(message: "There are no dogs to display\nEnter My Dogs to add dogs", controller: self)
            }
        }
        Model.instance.getAllDogs()
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
        cell.dogImage.layer.cornerRadius = cell.dogImage.frame.size.width/2
        cell.dogImage.clipsToBounds = true
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
            expandController.isInMyDogs = false
            expandController.dog = dogs[selectedIndex]
        }
    }
}

