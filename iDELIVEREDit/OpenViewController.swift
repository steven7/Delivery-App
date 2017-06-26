//
//  OpenViewController.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/3/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

class OpenViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var loginButton:UIButton!
    
    @IBOutlet weak var recordLoadedButton:UIButton!
    
    @IBOutlet weak var recordDeliverdButton:UIButton!
    
    let shared = AppSingleton.sharedInstance
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        /*
        let defaults = UserDefaults.standard
        
        print(self.shared.tripInProgress)
        if(defaults.value(forKey: "tripInProgress") != nil ){
            print("trip is")
            print(defaults.value(forKey: "tripInProgress")!)
            let trip = defaults.value(forKey: "tripInProgress") as! Bool
          if( trip == true){
            let alert = UIAlertController(title: "Trip Was In Progress", message: "When the app was closed a trip was in progress. Do you want to return to that trip?",  preferredStyle: .alert)
            
            let firstAction = UIAlertAction(title: "OK", style: .default){ action in
                self.shared.tripInProgress = true
                self.performSegue(withIdentifier: "toLoadInTransit", sender: self)
            }
            let secondAction = UIAlertAction(title: "Cancel", style: .default){ action in
                defaults.set(false, forKey: "tripInProgress")
                self.shared.tripInProgress = false
                print("cancel pressed!!!")
            }
            
            alert.addAction(firstAction)
            alert.addAction(secondAction)
            present(alert, animated: true, completion:nil)
          }
        }
        */
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(shared.isUser()){
            recordLoadedButton.isEnabled = true
        }else{
            recordLoadedButton.isEnabled = false
        }
    }
    
    func buttonBorders(){
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = self.view.tintColor.cgColor
        
        recordLoadedButton.layer.cornerRadius = 5
        recordLoadedButton.layer.borderWidth = 1
        recordLoadedButton.layer.borderColor = self.view.tintColor.cgColor
        
        recordDeliverdButton.layer.cornerRadius = 5
        recordDeliverdButton.layer.borderWidth = 1
        recordDeliverdButton.layer.borderColor = self.view.tintColor.cgColor
    }
    
    func buttonBorders(button:UIButton){
        button.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = self.view.tintColor.cgColor
    }
}

