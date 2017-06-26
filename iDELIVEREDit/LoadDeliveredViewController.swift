//
//  LoadDeliveredViewController.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/18/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import MapKit
import MessageUI
import CoreLocation
import UIKit

class LoadDeliveredViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tractNameLabel: UILabel!
    @IBOutlet weak var tractLocationLabel: UILabel!
    @IBOutlet weak var loggerNameLabel: UILabel!
    @IBOutlet weak var fieldOneLabel: UILabel!
    @IBOutlet weak var fieldTwoLabel: UILabel!
    @IBOutlet weak var fieldThreeLabel: UILabel!
    
    @IBOutlet weak var deliveryPointField: UITextField!
    
    @IBOutlet weak var saveAndSendButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    let shared = AppSingleton.sharedInstance
    
    var mailSent:Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        shared.tripInProgress = false
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "tripInProgress")
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        deliveryPointField.delegate = self
        
        shared.tripInProgress = false
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        //self.navigationItem.hidesBackButton = true
        
        setLabels()
        
        saveAndSendButton.layer.cornerRadius = 5
        saveAndSendButton.layer.borderWidth = 1
        saveAndSendButton.layer.borderColor = self.view.tintColor.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool){
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 50
        }
        mapView?.setUserTrackingMode(.follow, animated: true)
    }
    
    func setLabels(){
        
        if(shared.load.truckTrailerID != ""){
            tractNameLabel.text = shared.load.truckTrailerID
        }else{
            tractNameLabel.text = "not entered"
            tractNameLabel.textColor = UIColor.lightGray
        }
        
        if(shared.load.tractLocationState != ""){
            tractLocationLabel.text = "\(shared.load.tractLocationState!), \(shared.load.tractLocationCountry!)"
        }else{
            tractLocationLabel.text = "not entered"
            tractLocationLabel.textColor = UIColor.lightGray
        }
        
        if(shared.load.logger != ""){
            loggerNameLabel.text = shared.load.logger
        }else{
            loggerNameLabel.text = "not entered"
            loggerNameLabel.textColor = UIColor.lightGray
        }
        
        /// i didnt change the name of labels on this view controller
        if(shared.load.tractName != ""){
            fieldOneLabel.text = shared.load.tractName
        }else{
            fieldOneLabel.text = "not entered"
            fieldOneLabel.textColor = UIColor.lightGray
        }
        
        if(shared.load.poNumber != ""){
            fieldTwoLabel.text = shared.load.poNumber
        }else{
            fieldTwoLabel.text = "not entered"
            fieldTwoLabel.textColor = UIColor.lightGray
        }
        
        if(shared.load.gatePassNumber != ""){
            fieldThreeLabel.text = shared.load.gatePassNumber
        }else{
            fieldThreeLabel.text = "not entered"
            fieldThreeLabel.textColor = UIColor.lightGray        }
        
    }
    
    
    @IBAction func getLocationFromCoordinates() {
        
        reverseGeoDeceode()

    }
    
    func reverseGeoDeceode(){
        let lattitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lattitude!, longitude: longitude!)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                //print(pm.locality!)
                self.infoFromPlacemark(placemark: pm)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
        print(lattitude!)
        print(longitude!)
    }
    
    func infoFromPlacemark(placemark: CLPlacemark){
        if placemark != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            print(placemark.addressDictionary!)
            print(placemark.subThoroughfare!)
            print(placemark.locality!)
            print(placemark.postalCode!)
            print(placemark.administrativeArea!)
            print(placemark.country!)
            
            let address = placemark.addressDictionary
            
            print(address?["Street"]! as Any)
            print(address?["City"]! as! String)
            print(address?["State"]! as! String)
            print(address?["ZIP"]! as! String)
            print(address?["Country"]! as! String)
            
            let street = address?["Street"]! as! String
            let city = address?["City"]! as! String
            let state = address?["State"]! as! String
            let zip = address?["ZIP"]! as! String
            let country = address?["Country"]! as! String
            
            let formattedAddressString = "\(street), \(city), \(state) \(zip), \(country)"
            
            
            shared.load.deliveryPoint = formattedAddressString
            self.deliveryPointField.text = formattedAddressString
            
            
        }
    }
    
    func saveValuesSoFar(){
        shared.load.deliveryPoint = deliveryPointField.text!
    }
    
    
    
    @IBAction func saveAndSendButtonPressed(_ sender: Any) {
        
        saveValuesSoFar()
        
        shared.load.printContents()
        
        
        if !MFMailComposeViewController.canSendMail() {
            mailError()
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        ///
        ///  set up email
        ///
        
        composeVC.setSubject("Delivery Summary")
        
        let emailDataString = createEmailString()
        composeVC.setMessageBody("Hello, \n\n Here is the delivery summary:\n\n\(emailDataString)\n\n Here is a csv containing the info", isHTML: false)
        
        shared.load.printContents()
        
        // set up excel file
        
        let fileName = "DeliverySummary.csv"
        let path = createCSVString(fileName: fileName)
        
        
        composeVC.addAttachmentData(NSData(contentsOf: path as URL)! as Data, mimeType: "text/csv", fileName: fileName)
        
        
        eraseInfo()
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func eraseInfo(){
        //erase info about trip
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "departurePoint")
        defaults.set(false, forKey: "tripInProgress")
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        //print(String(describing: defaults.value(forKey: "departurePoint")! ) )
        shared.load.clearLoad()
        shared.load.departurePoint = ""
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
    
    func getKeyboardHeight(notification: NSNotification)  -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y -= (2.2*getKeyboardHeight(notification: notification)/3)
    }
    
    func keyboardWillHide(notification: NSNotification){
 
        self.view.frame.origin.y = 0// += (getKeyboardHeight(notification)/2)
        
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

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //
    //
    //            mail stuff
    //
    //
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func createEmailString() -> String {
        
        let user = shared.user
        let load = shared.load
        
        var emailText = "User Info: \n Driver Name: \(user.driverName!) \n Driver Email: \(user.driverEmail!) \n Trailer/Truck Number: \(user.trucktrailerNumber!) \n Logging Compnay Name: \(user.loggingCompany!) \n Logging Foreman on Site: \(user.loggingForeman!) \n Logging Certification Number: \(user.loggerCertification!) \n Logger Email: \(user.loggerEmail!) \n Mill Rep Email: \(user.millRep!) \n"
        
        let otherEmailText = "Load Info: \n Track Location State: \(load.tractLocationState!) \n Track Location Country: \(load.tractLocationCountry!) \n Logger: \(load.logger!) \n Logger Mill ID: \(load.loggerMillID!) \n Truck/Trailer Number: \(load.truckTrailerID!) \n PO Number: \(load.poNumber!) \n Gate Pass Number: \(load.gatePassNumber!) \n Field One: \(load.fieldOne!) \n Field Two: \(load.fieldTwo!) \n"
        
        let moreEmailText = "Contents: \(load.contentsOne!), \(load.contentsTwo!) \n"
        
        print("what is the departure point?")
        print("\(load.departurePoint!)")
        
        print("what is the departure time?")
        print("\(load.departureTime!)")
        
        print("what is the delivery point?")
        print("\(load.deliveryPoint!)")
        
        let yetMoreEmailText = "Departure Point: \(load.departurePoint!) \n Departure Time: \(load.departureTime!) \n Trip Time: \(load.currentTripTime!) \n "
        
        let yetEvenMoreEmailText = "Delivery Point: \(load.deliveryPoint!) \n"
        
        emailText.append(otherEmailText)
        emailText.append(moreEmailText)
        emailText.append(yetMoreEmailText)
        emailText.append(yetEvenMoreEmailText)
        
        return emailText
    }
    
    func createCSVString(fileName:String ) -> NSURL {
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = ""
        
        let user = shared.user
        let load = shared.load
        
        let theCsvText = "User Info,  \n Driver Name, \(user.driverName!) \n Driver Email, \(user.driverEmail!) \n Trailer/Truck Number, \(user.trucktrailerNumber!) \n Logging Compnay Name, \(user.loggingCompany!) \n Logging Foreman on Site, \(user.loggingForeman!) \n Logging Certification Number, \(user.loggerCertification!) \n Logger Email, \(user.loggerEmail!) \n Mill Rep Email, \(user.millRep!)\n"
        
        let otherCsvText = "Load Info,  \n Track Location State, \(load.tractLocationState!) \n Track Location Country, \(load.tractLocationCountry!) \n Logger, \(load.logger!) \n Logger Mill ID, \(load.loggerMillID!) \n Truck/Trailer Number, \(load.truckTrailerID!) \n PO Number, \(load.poNumber!) \n Gate Pass Number, \(load.gatePassNumber!) \n Field One, \(load.fieldOne!) \n Field Two, \(load.fieldTwo!) \n "
        
        let moreCsvText = "Contents, \(load.contentsOne!) and \(load.contentsTwo!) \n"
        
        let escapedPoint = load.departurePoint!.replacingOccurrences(of: ",", with: " ")
        let escapedTime = load.departureTime!.replacingOccurrences(of: ",", with: " ")
        let yetMoreCsvText = "Departure Point, \(escapedPoint) \n Departure Time, \(escapedTime) \n Trip Time, \(load.currentTripTime!) \n "
        
        let escapedAddress = load.deliveryPoint!.replacingOccurrences(of: ",", with: " ")
        let yetEvenMoreCsvText = "Delivery Point, \(escapedAddress) \n"
        
        csvText.append(theCsvText)
        csvText.append(otherCsvText)
        csvText.append(moreCsvText)
        csvText.append(yetMoreCsvText)
        csvText.append(yetEvenMoreCsvText)
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        return path! as NSURL
        
    }
    
    func oldcreateCSVString(fileName:String ) -> NSURL {
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var emailText = "Field,Decription,Picture\n"
        var csvText = "Field,Decription,Picture\n"
        
        
        /*
        if NSUserDefaults.standardUserDefaults().valueForKey("businessName") != nil{
            let newLine = "Business Name,\(NSUserDefaults.standardUserDefaults().valueForKey("businessName")!),  \n"
            let emailLine = "Business Name: \(NSUserDefaults.standardUserDefaults().valueForKey("businessName")!),  \n"
            csvText.appendContentsOf(newLine)
            emailText.appendContentsOf(emailLine)
        }
        if NSUserDefaults.standardUserDefaults().valueForKey("facilityAddress") != nil{
            let newLine = "Facility Address,\(NSUserDefaults.standardUserDefaults().valueForKey("facilityAddress")!),  \n"
            csvText.appendContentsOf(newLine)
            
        }
        if NSUserDefaults.standardUserDefaults().valueForKey("userPhoneNumber") != nil{
            let newLine = "User Phone Number,\(NSUserDefaults.standardUserDefaults().valueForKey("userPhoneNumber")!), \n"
            csvText.appendContentsOf(newLine)
        }
        if NSUserDefaults.standardUserDefaults().valueForKey("userEmailAddress") != nil{
            let newLine = "User Email Address,\(NSUserDefaults.standardUserDefaults().valueForKey("userEmailAddress")!), \n"
            csvText.appendContentsOf(newLine)
        }
        if NSUserDefaults.standardUserDefaults().valueForKey("userSupervisorsName") != nil{
            let newLine = "User Supervisors Name,\(NSUserDefaults.standardUserDefaults().valueForKey("userSupervisorsName")!), \n"
            csvText.appendContentsOf(newLine)
        }
        if NSUserDefaults.standardUserDefaults().valueForKey("userSupervisorsEmail") != nil{
            let newLine = "User Supervisors Email,\(NSUserDefaults.standardUserDefaults().valueForKey("userSupervisorsEmail")!), \n"
            csvText.appendContentsOf(newLine)
        }
        // let fieldDict = [[0:"Goods Description"],[1:"Location Recieved"],[2:"PO#"],[3:"Weight"],[4:"BOL# Description"],[10:"Rebate"],[11:"Cost"],[12:"Date Recieved"],[13:"Payment Due Date"],[14:"Goods Description"],[15:"Goods Description"]]
        
        
        
        do {
            try csvText.writeToURL(path!, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        */
        
        return path! as NSURL
    }
    

    func mailError(){
        let alertController = UIAlertController(title: "Error", message: "Cannot send email. You most likely need set up the deafault mail app", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil) //You can use a block here to handle a press on this button
        
        alertController.addAction(actionOk)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
            self.mailSent = true
            controller.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "toStart", sender: self)
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
        if(mailSent){
            
            //clearDicts()
            self.performSegue(withIdentifier: "toStart", sender: self)
        }
    }
 
}
