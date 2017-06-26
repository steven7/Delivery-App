//
//  CustomQuestionCell.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/3/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import UIKit

class CustomQuestionCell: UITableViewCell{
    
    let shared = AppSingleton.sharedInstance
    
    @IBOutlet weak var customLabel: UILabel!
    
    @IBOutlet weak var customSegment: UISegmentedControl!
    
    @IBAction func selectorPressed(_ sender: Any) {
        let content = customLabel.text
        let selected = customSegment.titleForSegment(at: customSegment.selectedSegmentIndex)!
        if(selected == "Yes"){
            setValuesForContent(contentName: content!)
        }
    }
    
    func updateSelectorFromDict(){
    }
    
    func updateSelectorFromDict(contentName: String){
        
        switch(contentName){
        case "Pulpwood":
            if(shared.load.pulpwood == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Chip 'n saw":
            if(shared.load.chipnSaw == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Saw logs":
            if(shared.load.sawlogs == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Ply/veneer logs":
            if(shared.load.plyVeneerLogs == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Poles":
            if(shared.load.poles == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Fuel chips":
            if(shared.load.fuelChips == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Chip mill chips":
            if(shared.load.chipMillChips == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Pine":
            if(shared.load.pine == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Hardwood":
            if(shared.load.hardwood == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Mixed":
            if(shared.load.mixed == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        case "Other":
            if(shared.load.other == true){
                customSegment.selectedSegmentIndex = 0
            }else{
                customSegment.selectedSegmentIndex = 1
            }
        default:
            break
        }
        
    }
    
    func setValuesForContent(contentName: String){
        
        switch(contentName){
        case "Pulpwood":
            shared.load.pulpwood = true
        case "Chip 'n saw":
            shared.load.chipnSaw = true
        case "Saw logs":
            shared.load.sawlogs = true
        case "Ply/veneer logs":
            shared.load.plyVeneerLogs = true
        case "Poles":
            shared.load.poles = true
        case "Fuel chips":
            shared.load.fuelChips = true
        case "Chip mill chips":
            shared.load.chipMillChips = true
        case "Pine":
            shared.load.pine = true
        case "Hardwood":
            shared.load.hardwood = true
        case "Mixed":
            shared.load.mixed = true
        case "Other":
            shared.load.other = true
        default:
            break
        }
        
    }
    
}
