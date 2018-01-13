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
    var hideSpinner:Bool = false
    
    @IBAction func unwindToMyDogs(segue: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddDogButton))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "All Dogs", style: .done, target: self, action: #selector(self.backToHome))
        
        Model.instance.getMyDogs(completionBlock: { (dogs) in
            if dogs != nil{
                self.dogs.removeAll()
                self.dogs = dogs!
                self.dogsTableView.reloadData()
            }
            else{
                HelpFunctions.displayAlertmessage(message: "There are no dogs to display\nPress the + button to add", controller: self)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(hideSpinner){
            HelpFunctions.hideSpinner()
        }
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
        cell.dogImage.layer.cornerRadius = cell.dogImage.frame.size.width/2
        cell.dogImage.clipsToBounds = true
        cell.dogImage.loadImageUsingCacheWithURL(urlString: dogs[indexPath.row].imageURL!, controller: self)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "expandDog", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "expandDog"){
            let expandController:ExpandViewController = segue.destination as! ExpandViewController
            expandController.isInMyDogs = true
            expandController.dog = dogs[selectedIndex]
        }
        else if(segue.identifier == "addDog"){
            let addController:ManageSingleDogViewController = segue.destination as! ManageSingleDogViewController
            addController.isEditMode = false
            addController.isUploaded = false
        }
    }
}
