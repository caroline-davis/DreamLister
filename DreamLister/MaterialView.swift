//
//  MaterialView.swift
//  DreamLister
//
//  Created by Caroline Davis on 11/04/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
// anything that has the uiview will be able to use this styling

private var materialKey = false

extension UIView {

    // this makes you able to switch on or off this design in the view on main storyboard!! really cool!!!!!
    
    @IBInspectable var materialDesign: Bool {
        
        get {
           return materialKey
        }
        set {
            materialKey = newValue
            
            if materialKey == true {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
        
    }
    
 

}
