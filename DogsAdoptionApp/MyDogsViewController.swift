//
//  MyDogsViewController.swift
//  DogsAdoptionApp
//
//  Created by admin on 23/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class MyDogsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dogsTableView: UITableView!
    var dogs = [Dog]()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddDogButton))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "All Dogs", style: .done, target: self, action: #selector(self.backToHome))
        
        let dataBaseRef = Database.database().reference()
        
        dataBaseRef.child("Users").child((Auth.auth().currentUser?.uid)!).child("Dogs").observe(.value, with: {(snapshot) in
            if snapshot.childrenCount > 0{
                self.dogs.removeAll()
                for dogs in snapshot.children.allObjects as! [DataSnapshot]{
                    let dogObject = dogs.value as? [String:String]
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
                self.dogsTableView.reloadData()
            }
        })
    }
    
    @objc func backToHome() {
        self.performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func tapAddDogButton(){
        self.performSegue(withIdentifier: "addDog", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogCellTableViewCell
        cell.dogName.text = dogs[indexPath.row].name
        cell.dogAge.text = dogs[indexPath.row].age
        cell.dogCity.text = dogs[indexPath.row].city
        
        let url = URL(string: dogs[indexPath.row].imageURL!)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data,response,error) in
            if error != nil{
                HelpFunctions.displayAlertmessage(message: "Error loading image", controller: self)
            }
            DispatchQueue.main.async{
                cell.dogImage.image = UIImage(data:data!)
            }
        }).resume()
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "expandDog", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "expandDog"){
            let expandController:ExpandViewController = segue.destination as! ExpandViewController
            expandController.dog = dogs[selectedIndex]
        }
    }
}
