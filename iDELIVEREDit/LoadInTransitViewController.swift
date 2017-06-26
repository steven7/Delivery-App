//
//  LoadInTransitViewController.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/3/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import MapKit
import CoreLocation
import Foundation
import UIKit

class LoadInTransitViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var arrivedButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    var timer = Timer()
    var secCount = 0;
    var minCount = 0;
    var hourCount = 0;
    
    var lattitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    let distanceSpan:Double = 500
    let formatter = NumberFormatter()
    
    //formatter.minimumIntegerDigits = 2
    
    let shared = AppSingleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.navigationItem.hidesBackButton = true
        
        if(shared.tripInProgress == false){
        
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let formattedDate = dateFormatter.string(from: date )
        
        
            currentTimeLabel.text = "\(formattedDate)"
            shared.load.departureTime = "\(formattedDate)"
            shared.load.departureTimeAsDate = date
            shared.load.departurePoint = ""
            
            startTimer()
        
            secLabel.text = "0"
            minLabel.text = "0"
            hourLabel.text = "0"
        
        }else{
            
            let defaults = UserDefaults.standard
            
            shared.load.currentTripTime = String(describing: defaults.value(forKey: "departureTime")! )
            //shared.load.departureTimeAsDate = defaults.value(forKey: "departureTimeAsDate") as! Date
            
            shared.load.tractLocationState = String(describing: defaults.value(forKey: "tractLocationState")!)
            
            shared.load.tractLocationCountry = String(describing: defaults.value(forKey: "tractLocationCountry")! )
            shared.load.logger = String(describing: defaults.value(forKey: "logger")! )
            shared.load.loggerMillID = String(describing: defaults.value(forKey: "loggerMillID")! )
            shared.load.truckTrailerID = String(describing: defaults.value(forKey: "truckTrailerID")! )
            shared.load.poNumber = String(describing: defaults.value(forKey: "poNumber")! )
            shared.load.gatePassNumber = String(describing: defaults.value(forKey: "gatePassNumber")! )
            shared.load.fieldOne = String(describing: defaults.value(forKey: "fieldOne")! )
            shared.load.fieldTwo = String(describing: defaults.value(forKey: "fieldTwo")! )
            shared.load.fieldThree = String(describing: defaults.value(forKey: "fieldThree")! )
            
            shared.load.contentsOne = String(describing: defaults.value(forKey: "contentsOne")! )
            shared.load.contentsTwo = String(describing: defaults.value(forKey: "contentsTwo")! )
            
            
            toForeground()
        }
        
        
        buttonBorders()
        
    }
    override func viewWillAppear(_ animated: Bool){
        print("is this view will be appearin!?")
    }
    
    override func viewDidAppear(_ animated: Bool){
        
        print("is this view did be appearin!?")
        
        subscribeToNotifications()
        
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        
        
        
        mapView?.setUserTrackingMode(.follow, animated: true)
        
        if(shared.tripInProgress == false){
            
            print("we NOT got a trip going on")
            
            shared.tripInProgress = true
            
            /*
            let lattitude = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude
    
            pointLabel.text = String(format: "%.6f \n %.6f", lattitude! as Double, longitude! as Double)
            shared.load.departurePoint = String(format: "%.6f ,  %.6f", lattitude! as Double, longitude! as Double)
            defaults.set("\(lattitude!)", forKey: "departureLat")
            defaults.set("\(longitude!)", forKey: "departureLong")
            */
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "tripInProgress")
            //defaults.set("true", forKey: "tripInProgress")
            defaults.set("\(currentTimeLabel.text!)", forKey: "departureTime")
            
            //defaults.set("\(hourCount) : \(minCount) : \(secCount)", forKey: "currentTripTime")
        
            
        }else{
            
            print("we got a trip going on")
            
            let defaults = UserDefaults.standard

            /*
            let defaults = UserDefaults.standard
            
            
            currentTimeLabel.text = defaults.value(forKey: "departureTime") as! String?
            
            let oldDate = shared.load.departureTimeAsDate!
            
            let date = Date()
            
            let calendar = Calendar.current
            
            let sec = calendar.component(.second, from: date)
            let min = calendar.component(.minute, from: date)
            let hour = calendar.component(.hour, from: date)
            
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.zeroFormattingBehavior = .pad
            
            let string = formatter.string(from: oldDate, to: date)
            
            //let thedate = Date(timeIntervalSinceReferenceDate: oldDate)
            
            let thesec = calendar.component(.second, from: oldDate)
            let themin = calendar.component(.minute, from: oldDate)
            let thehour = calendar.component(.hour, from: oldDate)
            
            let oldSecCount = calendar.component(.second, from: oldDate)
            let oldMinCount = calendar.component(.minute, from: oldDate)
            let oldHourCount = calendar.component(.hour, from: oldDate)
            
            
            
            print("start: \(oldDate)")
            print("end: \(date)")
            print("diff: \(string)")
            
            print("departed: \(oldHourCount) \(oldMinCount) \(oldHourCount)")
            print("arrival: \(hour) \(min) \(sec)")
            print("difference: \(hour - oldHourCount) \(min - oldMinCount) \(sec - oldSecCount)")
            
            self.secCount = sec - oldSecCount
            self.minCount = min - oldMinCount
            self.hourCount = hour - oldHourCount
            
            secLabel.text = String(self.secCount)
            minLabel.text = String(self.minCount)
            hourLabel.text = String(self.hourCount)
            
            startTimer()
 
 
            
            
            currentTimeLabel.text = defaults.value(forKey: "departureTime") as! String?
            
            let oldDate = defaults.value(forKey: "departureTimeAsDate") as! Date
            
            let date = Date()
            
            let timeInterval = date.timeIntervalSince(oldDate)
            
            
            let thehour = (Int(timeInterval))/3600
            let themin = Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60
            let thesec = Int(timeInterval.truncatingRemainder(dividingBy: 60) )
            
            self.secCount = thesec
            self.minCount = themin
            self.hourCount = thehour
            
            secLabel.text = String(self.secCount)
            minLabel.text = String(self.minCount)
            hourLabel.text = String(self.hourCount)
            */
            
            
            
            shared.load.departureLat = String(describing: defaults.value(forKey: "departureLat")! )
            shared.load.departureLong =  String(describing: defaults.value(forKey: "departureLong")! )
            shared.load.departureTime =  String(describing: defaults.value(forKey: "departureTime")! )
            shared.load.departurePoint = String(describing: defaults.value(forKey: "departurePoint")! )
            print("load dep point = \(shared.load.departurePoint)")
            //pointLabel.text = defaults.value(forKey: "departurePoint") as! String?
            
            
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //only 'update' first location
        print("is this called?")
        print(shared.load.departurePoint)
        
        if(shared.load.departurePoint == ""){// if empty its ""
            let lattitude = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude
        
            
            shared.load.departurePoint = String(format: "%.6f ,  %.6f", lattitude! as Double, longitude! as Double)
            print("departure point set to \(shared.load.departurePoint)")
            
            let defaults = UserDefaults.standard
            defaults.set("\(lattitude!)", forKey: "departureLat")
            defaults.set("\(longitude!)", forKey: "departureLong")
            
            //print("pointLabel.text set!!")
            //pointLabel.text = String(format: "%.6f \n %.6f", lattitude! as Double, longitude! as Double)
            
            updatePointLabel(text: String(format: "%.6f \n %.6f", lattitude! as Double, longitude! as Double))
            
            defaults.set("\(pointLabel.text!)", forKey: "departurePoint")
            
        }else{
            //let defaults = UserDefaults.standard
            //shared.load.departurePoint = String(describing: defaults.value(forKey: "departurePoint")! )
            updatePointLabel(text: shared.load.departurePoint)
        }
        
    }
    
    func updatePointLabel(text: String){
        print("pointLabel.text set!!")
        pointLabel.text = text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func buttonBorders(){
        
        arrivedButton.layer.cornerRadius = 5
        arrivedButton.layer.borderWidth = 1
        arrivedButton.layer.borderColor = self.view.tintColor.cgColor
        
    }
    
    func saveValuesSoFar(){
        //shared.load.departureLat = String(self.lattitude)
        //shared.load.departureLong = String(self.longitude)
        //shared.load.departureTime = currentTimeLabel.text!
        shared.load.currentTripTime = "\(hourCount) : \(minCount) : \(secCount)"
    }
    
    func toForeground(){
        
        print("to foreground")
        
        if(shared.tripInProgress == true){
        
        print("we got a trip going on")
        let defaults = UserDefaults.standard
        
        
        currentTimeLabel.text = defaults.value(forKey: "departureTime") as! String?
        
        let oldDate = defaults.value(forKey: "departureTimeAsDate") as! Date
            
        //shared.load.departureTimeAsDate!
            
        let date = Date()
        
        let timeInterval = date.timeIntervalSince(oldDate)
            
            
        let thehour = (Int(timeInterval))/3600
        let themin = Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60
        let thesec = Int(timeInterval.truncatingRemainder(dividingBy: 60) )
            
            
        let calendar = Calendar.current
        
        let sec = calendar.component(.second, from: date)
        let min = calendar.component(.minute, from: date)
        let hour = calendar.component(.hour, from: date)
        
        
        let oldSecCount = calendar.component(.second, from: oldDate)
        let oldMinCount = calendar.component(.minute, from: oldDate)
        let oldHourCount = calendar.component(.hour, from: oldDate)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        let string = formatter.string(from: oldDate, to: date)
        
        
            
        print("start: \(oldDate)")
        print("end: \(date)")
        print("diff: \(string)")
        print("other diff: \(timeInterval)")
        
            
        print("departed: \(oldHourCount) \(oldMinCount) \(oldHourCount)")
        print("arrival: \(hour) \(min) \(sec)")
        print("difference: \(hour - oldHourCount) \(min - oldMinCount) \(sec - oldSecCount)")
        print("difference: \(thehour) \( themin ) \(thesec)")
            
            
        self.secCount = thesec
        self.minCount = themin
        self.hourCount = thehour
        
        secLabel.text = String(self.secCount)
        minLabel.text = String(self.minCount)
        hourLabel.text = String(self.hourCount)
        
        startTimer()
            
        }
    }
    
    func goingToBackground(){
        print("goin to background")
        shared.tripInProgress = true
        timer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if(segue.identifier == "toLoadDelivered"){
        //
        //}
        saveValuesSoFar()
        
        
        unsubscribeFromNotifications()
        timer.invalidate()
    }
    
    @objc( locationManager:didUpdateToLocation:fromLocation:)
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        //func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //func locationManager(CLLocationManager, didUpdateTo: CLLocation, from: CLLocation)
        if let mapView = self.mapView {
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(LoadInTransitViewController.countUp), userInfo: nil, repeats: true)
    }
    
    func countUp() {
        
        print(secCount)
   
        if(secCount > 58){
            secCount = 0
            minCount += 1
            minLabel.text = String(describing: minCount)
            //minLabel.text = formatter.string(from: 0)
            print("yo")
        }
        else if(minCount > 58){
            secCount = 0
            minCount = 0
            hourCount += 1
            hourLabel.text = String(describing: hourCount)
            //minLabel.text = formatter.string(from: 0)
            print("yo")
        }
        else{
            secCount+=1
            //secLabel.text = String(describing: secCount)
        }
        
        
        secLabel.text = String(describing: secCount)
        
        minLabel.text = String(describing: minCount)
        
        hourLabel.text = String(describing: hourCount)
        
        shared.secCount = secCount
        shared.minCount = minCount
        shared.hourCount = hourCount
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func subscribeToNotifications(){
        print("did the keyboard show?")
        NotificationCenter.default.addObserver(self, selector: #selector(goingToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func unsubscribeFromNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
}
