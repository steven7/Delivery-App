//
//  User.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/5/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import Foundation

class currentUser  {
    
    var driverName:String!
    var driverEmail:String!
    var trucktrailerNumber:String!
    var loggingCompany:String!
    var loggingForeman:String!
    var loggerCertification:String!
    var loggerEmail:String!
    var millRep:String!
    
    init(){
        driverName = ""
        driverEmail = ""
        trucktrailerNumber = ""
        loggingCompany = ""
        loggingForeman = ""
        loggerCertification = ""
        loggerEmail = ""
        millRep = ""
    }
    
    func setUser(driverName: String, driverEmail: String, trucktrailerNumber: String, loggingCompany: String, loggingForeman: String, loggerCertification: String, loggerEmail: String, millRep: String){
        
        self.driverName = driverName
        self.driverEmail = driverEmail
        self.trucktrailerNumber = trucktrailerNumber
        self.loggingCompany = loggingCompany
        self.loggingForeman = loggingForeman
        self.loggerCertification = loggerCertification
        self.loggerEmail = loggerEmail
        self.millRep = millRep
    }
    
    func printContents(){
        print(driverName)
        print(driverEmail)
        print(trucktrailerNumber)
        print(loggingCompany)
        print(loggingForeman)
        print(loggerCertification)
        print(loggerEmail)
        print(millRep)
    }
}
