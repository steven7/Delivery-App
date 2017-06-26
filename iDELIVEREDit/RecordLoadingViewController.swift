//
//  RecordLoadingViewController.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/3/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import UIKit

class RecordLoadingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var trackLocationStateField: UITextField!
    @IBOutlet weak var trackLocationCountryField: UITextField!
    @IBOutlet weak var trackNameField: UITextField!
    @IBOutlet weak var loggerField: UITextField!
    @IBOutlet weak var loggerMillIDNumberField: UITextField!
    @IBOutlet weak var trucktrailerNumberField: UITextField!
    @IBOutlet weak var PONumberField: UITextField!
    @IBOutlet weak var GatePassNumberField: UITextField!
    @IBOutlet weak var fieldOneField: UITextField!
    @IBOutlet weak var fieldTwoField: UITextField!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentOne: UISegmentedControl!
    @IBOutlet weak var segmentTwo: UISegmentedControl!
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    let questionsList = ["Pulpwood", "Chip 'n saw", "Saw logs", "Ply/veneer logs", "Poles", "Fuel chips", "Chip mill chips", "Pine", "Hardwood", "Mixed", "Other"]
    
    let questionsDict:[String:Int] = ["Pulpwood":0, "Chip 'n saw":1, "Saw logs":2, "Ply/veneer logs":3, "Poles":0, "Fuel chips":0, "Chip mill chips":0, "Pine":0, "Hardwood":0, "Mixed":0, "Other":0]
    
    var sharedList = [Bool]()
    
    let shared = AppSingleton.sharedInstance
    
    var contentsOne = ""
    var contentsTwo = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        trackLocationStateField.delegate = self
        trackLocationCountryField.delegate = self
        trackNameField.delegate = self
        loggerField.delegate = self
        loggerMillIDNumberField.delegate = self
        trucktrailerNumberField.delegate = self
        PONumberField.delegate = self
        GatePassNumberField.delegate = self
        fieldOneField.delegate = self
        fieldTwoField.delegate = self
        
        
        sharedList = [shared.load.pulpwood, shared.load.chipnSaw, shared.load.sawlogs, shared.load.plyVeneerLogs, shared.load.poles, shared.load.fuelChips, shared.load.chipMillChips, shared.load.pine, shared.load.hardwood, shared.load.mixed, shared.load.other]
        
        buttonBorders()
        
        segmentOne.goVertical()
        segmentTwo.goVertical()
        
        seeIfTripWasInProgress()
    }
    
    func buttonBorders(){
        scanButton.layer.cornerRadius = 5
        scanButton.layer.borderWidth = 1
        scanButton.layer.borderColor = self.view.tintColor.cgColor
        
        startButton.layer.cornerRadius = 5
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = self.view.tintColor.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Barcode Feature Not Enabled", message: "Please contact your mill rep to enable the barcode feature",  preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(firstAction) // 4
        present(alert, animated: true, completion:nil) // 6
    }

    @IBAction func segmentOneSelected(_ sender: Any) {
        let selectedIndex = segmentOne.selectedSegmentIndex
        switch(selectedIndex){
        case 0:
            contentsOne = "Pine"
        case 1:
            contentsOne = "Hardwood"
        case 2:
            contentsOne = "Mixed"
        case 3:
            contentsOne = "Other"
        default:
        break
        }
    }
    
    @IBAction func segmentTwoSelected(_ sender: Any) {
        let selectedIndex = segmentOne.selectedSegmentIndex
        switch(selectedIndex){
        case 0:
            contentsTwo = "Pulpwood"
        case 1:
            contentsTwo = "Chip 'n saw"
        case 2:
            contentsTwo = "Saw logs"
        case 3:
            contentsTwo = "Ply/veneer logs"
        case 4:
            contentsTwo = "Poles"
        case 5:
            contentsTwo = "Fuel chips"
        case 6:
            contentsTwo = "Chip mill chips"
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        saveValuesSoFar()
    }
    
    func seeIfTripWasInProgress(){
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
    }
    
    func saveValuesSoFar(){
        
        shared.load.tractLocationState = trackLocationStateField.text!
        shared.load.tractLocationCountry = trackLocationCountryField.text!
        shared.load.tractName = trackNameField.text!
        shared.load.logger = loggerField.text!
        shared.load.loggerMillID = loggerMillIDNumberField.text!
        shared.load.truckTrailerID = trucktrailerNumberField.text!
        shared.load.poNumber = PONumberField.text!
        shared.load.gatePassNumber = GatePassNumberField.text!
        shared.load.fieldOne = fieldOneField.text!
        shared.load.fieldTwo = fieldTwoField.text!
        
        
        shared.load.contentsOne = contentsOne
        shared.load.contentsTwo = contentsTwo
         
    }
    
    ////////////////
    ///
    ///   Tableview 
    ///
    ////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return questionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomQuestionCell
        
        cell.customLabel.text = questionsList[indexPath.row]
        
        //cell.updateSelectorFromDict(contentName: questionsList[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.performSegueWithIdentifier("toSetPrefill", sender: self)
    }

    ////////////////
    ///
    ///   Keyboard
    ///
    ////////////////
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
}
