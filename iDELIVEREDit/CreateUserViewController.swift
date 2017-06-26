//
//  CreateUserViewController.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/5/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import UIKit
import CoreData

class CreateUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var driverNameField: UITextField!
    
    @IBOutlet weak var driverEmailField: UITextField!
    
    @IBOutlet weak var trucktrailerField: UITextField!
    
    @IBOutlet weak var loggingCompanyField: UITextField!
    
    @IBOutlet weak var loggingForemanField: UITextField!
    
    @IBOutlet weak var loggerCertificationField: UITextField!
    
    @IBOutlet weak var loggerEmailField: UITextField!
    
    @IBOutlet weak var millRepField: UITextField!
    
    @IBOutlet weak var saveButton:UIButton!
    
    var fieldTag = 0
    var currentField:UITextField!
    var currentlyEditing = false
    
    let shared = AppSingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentField = driverNameField
        
        driverNameField.delegate = self
        driverEmailField.delegate = self
        trucktrailerField.delegate = self
        loggingCompanyField.delegate = self
        loggingForemanField.delegate = self
        loggerCertificationField.delegate = self
        loggerEmailField.delegate = self
        millRepField.delegate = self
        
        
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = self.view.tintColor.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        var driverName = ""
        var driverEmail = ""
        var trucktrailerNumber = ""
        var loggingCompany = ""
        var loggingForeman = ""
        var loggerCertification = ""
        var loggerEmail = ""
        var millRep = ""
        
        //if driverNameField != "" {
        //    driverName
        //}
        
        driverName = driverNameField.text!
        driverEmail = driverEmailField.text!
        trucktrailerNumber = trucktrailerField.text!
        loggingCompany = loggingCompanyField.text!
        loggingForeman = loggingForemanField.text!
        loggerCertification = loggerCertificationField.text!
        loggerEmail = loggerEmailField.text!
        millRep = millRepField.text!
        
        //shared.user.driverName = driverName
        
        shared.user.setUser(driverName: driverName, driverEmail: driverEmail, trucktrailerNumber: trucktrailerNumber, loggingCompany: loggingCompany, loggingForeman: loggingForeman, loggerCertification: loggerCertification, loggerEmail: loggerEmail, millRep: millRep)
        shared.setUser(state: true)
        
        
        print(driverName)
        print(driverEmail)
        print(trucktrailerNumber)
        print(loggingCompany)
        print(loggingForeman)
        print(loggerCertification)
        print(loggerEmail)
        print(millRep)
        
        //saveUser(thedriverName: driverName, thedriverEmail: driverEmail, trucktrailerNumber: trucktrailerNumber, loggingCompany: loggingCompany, loggingForeman: loggingForeman, loggerCertification: loggerCertification, loggerEmail: loggerEmail, millRep: millRep)
        
        storeUser(thedriverName: driverName, thedriverEmail: driverEmail, trucktrailerNumber: trucktrailerNumber, loggingCompany: loggingCompany, loggingForeman: loggingForeman, loggerCertification: loggerCertification, loggerEmail: loggerEmail, millRep: millRep)
        
        createUserAlert()
        
    }
    
    func createUserAlert(){
        
        let alertController = UIAlertController(title: "User Saved", message: "The user is saved and is the current user", preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: {(alert :UIAlertAction!) in
                                        print("YOU PRESSED OK")
                                        self.performSegue(withIdentifier: "toStart", sender: self)
                                        //self.navigationController?.popToRootViewControllerAnimated(true)
        }) //You can use a block here to handle a press on this button
        
        alertController.addAction(actionOk)
        
        present(alertController, animated: true, completion:nil)
        
        /*
        let alert = UIAlertController(title: "Comming Soon!", message: "Barcode feature coming in the next update!  ",  preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(firstAction) // 4
        present(alert, animated: true, completion:nil) // 6
         */
    }
    
    func butonBorders(){
        //newButton.layer.cornerRadius = 5
        //newButton.layer.borderWidth = 1
        //newButton.layer.borderColor = self.view.tintColor.CGColor
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeUser(thedriverName: String, thedriverEmail: String, trucktrailerNumber: String, loggingCompany: String, loggingForeman: String, loggerCertification: String, loggerEmail: String, millRep: String){
        
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        print(thedriverName)
        print(thedriverEmail)
        
        transc.setValue(thedriverName, forKey: "driverName")
        transc.setValue(thedriverEmail, forKey: "driverEmail")
        transc.setValue(trucktrailerNumber, forKey: "trucktrailerNumber")
        transc.setValue(loggingCompany, forKey: "loggingCompany")
        transc.setValue(loggingForeman, forKey: "loggingForeman")
        transc.setValue(loggerCertification, forKey: "loggerCertification")
        transc.setValue(loggerEmail, forKey: "loggerEmail")
        transc.setValue(millRep, forKey: "millRep")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
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
    
    //////
    ///  fix the keyboard covering things issue
    //////
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing yo")
        fieldTag = textField.tag
        currentField = textField
        //print(fieldTag)
        print("the actual when begin editing value: \(fieldTag) ")
        //currentTextField = textField
        
    }
    
    func getKeyboardHeight(notification: NSNotification)  -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        print("WillShow the actual value will show: \(fieldTag) ")
        print("WillShow keyboard up?: \(self.currentlyEditing) ")
        if(currentlyEditing == false ){
            if ( (currentField == loggerCertificationField )  ){
                // move view accordingly
                //if(self.view.frame.origin.y == 0){
                self.view.frame.origin.y -= (2.2*getKeyboardHeight(notification: notification)/3)
                currentlyEditing = true
                // }
            }
            else if ( (currentField == loggerEmailField )  ){
                // move view accordingly
                //if(self.view.frame.origin.y == 0){
                self.view.frame.origin.y -= (2.2*getKeyboardHeight(notification: notification)/3)
                currentlyEditing = true
                // }
            }
            else if( (currentField == millRepField ) ){
                //if(self.view.frame.origin.y == 0){
                self.view.frame.origin.y -= (2.6*getKeyboardHeight(notification: notification)/3)
                currentlyEditing = true
                // }
            }
        }
    }

    func keyboardWillHide(notification: NSNotification){
        //print(fieldTag)
        print("WillHide the actual value will hide: \(fieldTag) ")
        print("WillHide keyboard up?: \(self.currentlyEditing) ")
        
        print("WillHide origin pos: \(self.view.frame.origin.y)" )
        if(self.view.frame.origin.y != 0){
            self.view.frame.origin.y = 0// += (getKeyboardHeight(notification)/2)
            currentlyEditing = false
        }
        
    }
    
    func subscribeToKeyboardNotifications(){
        print("did the keyboard show?")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
