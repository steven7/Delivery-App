//
//  LoadUseViewController.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/5/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//


import UIKit
import CoreData

class LoadUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var tableView:UITableView!
    
    var users: [NSManagedObject] = []
    
    let shared = AppSingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func getUsers(){
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            users = try managedContext.fetch(fetchRequest)
            print(users.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = user.value(forKeyPath: "driverName") as? String
        cell.detailTextLabel?.text = user.value(forKeyPath: "driverEmail") as? String
        
        
        print("a user is here")
        print(user.value(forKeyPath: "driverName")! )
        print(user.value(forKeyPath: "driverEmail")! )
        
        return cell
        
    }
    
    func loadUser(user: NSManagedObject){
        shared.user.driverName = user.value(forKeyPath: "driverName") as? String
        shared.user.driverEmail = user.value(forKeyPath: "driverEmail") as? String
        shared.user.trucktrailerNumber = user.value(forKeyPath: "trucktrailerNumber") as? String
        shared.user.loggingCompany = user.value(forKeyPath: "loggingCompany") as? String
        shared.user.loggingForeman = user.value(forKeyPath: "loggingForeman") as? String
        shared.user.loggerCertification = user.value(forKeyPath: "loggerCertification") as? String
        shared.user.loggerEmail = user.value(forKeyPath: "loggerEmail") as? String
        shared.user.millRep = user.value(forKeyPath: "millRep") as? String
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        loadUser(user: user)
        shared.setUser(state: true)
        
        let alertController = UIAlertController(title: "User Selected", message: "This is now the current user", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: {(alert :UIAlertAction!) in
                                        print("YOU PRESSED OK")
                                        self.performSegue(withIdentifier: "toStart", sender: self)
        }) //You can use a block here to handle a press on this button
        
        alertController.addAction(actionOk)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
