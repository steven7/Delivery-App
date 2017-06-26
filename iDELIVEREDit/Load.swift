//
//  Load.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/5/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import Foundation


class Load  {
    
    var name:String!
    
    var tractLocationState:String!
    var tractLocationCountry:String!
    var tractName:String!
    var logger:String!
    var loggerMillID:String!
    var truckTrailerID:String!
    var poNumber:String!
    var gatePassNumber:String!
    var fieldOne:String!
    var fieldTwo:String!
    var fieldThree:String!
    
    var contentsOne:String!
    var contentsTwo:String!
    
    var pulpwood:Bool!
    var chipnSaw:Bool!
    var sawlogs:Bool!
    var plyVeneerLogs:Bool!
    var poles:Bool!
    var fuelChips:Bool!
    var chipMillChips:Bool!
    var pine:Bool!
    var hardwood:Bool!
    var mixed:Bool!
    var other:Bool!
    
    var departureLat:String!
    var departureLong:String!
    var departurePoint:String!
    var departureTime:String!
    var departureTimeAsDate:Date!
    var currentTripTime:String!
    
    var deliveryPoint:String!
    
    init(){
        
        name = ""
        tractLocationState = ""
        tractLocationCountry = ""
        tractName = ""
        logger = ""
        loggerMillID = ""
        truckTrailerID = ""
        poNumber = ""
        gatePassNumber = ""
        fieldOne = ""
        fieldTwo = ""
        fieldThree = ""
        
        contentsOne = ""
        contentsTwo = ""
        
        pulpwood = false
        chipnSaw = false
        sawlogs = false
        plyVeneerLogs = false
        poles = false
        fuelChips = false
        chipMillChips = false
        pine = false
        hardwood = false
        mixed = false
        other = false
        
        departureLat = ""
        departureLong = ""
        departurePoint = ""
        departureTime = ""
        currentTripTime = ""
        
        deliveryPoint = ""
    }
    
    func clearLoad(){
        
        name = ""
        tractLocationState = ""
        tractLocationCountry = ""
        tractName = ""
        logger = ""
        loggerMillID = ""
        truckTrailerID = ""
        poNumber = ""
        gatePassNumber = ""
        fieldOne = ""
        fieldTwo = ""
        fieldThree = ""
        
        contentsOne = ""
        contentsTwo = ""
        
        pulpwood = false
        chipnSaw = false
        sawlogs = false
        plyVeneerLogs = false
        poles = false
        fuelChips = false
        chipMillChips = false
        pine = false
        hardwood = false
        mixed = false
        other = false
        
        departureLat = ""
        departureLong = ""
        departurePoint = ""
        departureTime = ""
        currentTripTime = ""
        
        deliveryPoint = ""
    }
    
    func printContents(){
        
        print("ALL THE CONTENTS !!!!")
        
        print(name)
        print(tractLocationState)
        print(tractLocationCountry)
        print(logger)
        print(loggerMillID)
        print(truckTrailerID)
        print(poNumber)
        print(gatePassNumber)
        print(fieldOne)
        print(fieldTwo)
        print(fieldThree)
        
        print(pulpwood)
        print(chipnSaw)
        print(sawlogs)
        print(plyVeneerLogs)
        print(poles)
        print(fuelChips)
        print(chipMillChips)
        print(pine)
        print(hardwood)
        print(mixed)
        print(other)
        
        print(departureLat)
        print(departureLong)
        print(departureTime)
        print(currentTripTime)
        
        print(deliveryPoint)
    }
    
};
