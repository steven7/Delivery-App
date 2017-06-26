//
//  UserViewController.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/5/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var createButton:UIButton!
    
    @IBOutlet weak var loadButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //buttonBorders()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonBorders(){
        
        createButton.layer.cornerRadius = 5
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = self.view.tintColor.cgColor
        
        loadButton.layer.cornerRadius = 5
        loadButton.layer.borderWidth = 1
        loadButton.layer.borderColor = self.view.tintColor.cgColor
        
    }
    
    func buttonBorders(button:UIButton){
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = self.view.tintColor.cgColor
    }
}
