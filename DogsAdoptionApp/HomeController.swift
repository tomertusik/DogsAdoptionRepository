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
    
    var dogs : Array<Dog> = Array()
    var selectedIndex = Int()
    var isLoggedIn:User?

    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Dogs", style: .done, target: self, action: #selector(tapMyDogsButton))
        
        dogs.append(Dog(name: "Fang", age: "3", city: "Haifa", imageName: "Fang", description: "Very sweet dog", phoneForContact: "0508341931"))
        dogs.append(Dog(name: "Rexi", age: "6", city: "Tel-Aviv", imageName: "Rexi", description: "Very sweet dog", phoneForContact: "0508341931"))
        dogs.append(Dog(name: "Lola", age: "2", city: "Eilat", imageName: "Lola", description: "Very sweet dog asasfdsfhdfsbgjkdfghkdjsfghkjdfsgahf glshgakjfghls fghakghldksf hgakdjfhglksfhgajl hglskhjdlf ghlkjhd lfhgldkhjadlfhgklsh jadflghsgklhjsl alsdkhfglakgalsdhgl kahgladslghaldgk", phoneForContact: "0508341931"))
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
        cell.dogImage.image = UIImage(named:dogs[indexPath.row].imageName!)
        cell.dogName.text = dogs[indexPath.row].name
        cell.dogAge.text = dogs[indexPath.row].age
        cell.dogCity.text = dogs[indexPath.row].city
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

