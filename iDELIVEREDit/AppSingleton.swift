//
//  AppSingleton.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/19/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import Foundation

class AppSingleton{
    
    static let sharedInstance: AppSingleton = AppSingleton()
    
    var load = Load()
    
    var user = currentUser()
    
    var tripInProgress:Bool!
    
    var userSet:Bool!
    
    var secCount:Int!
    var minCount:Int!
    var hourCount:Int!
    
    init(){
        userSet = false
        tripInProgress = false
        secCount = 0
        minCount = 0
        hourCount = 0
    }
    
    func setUser(state:Bool){
        userSet = state
    }
    
    func isUser() -> Bool{
        return userSet
    }
}
