//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Caroline Davis on 11/04/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    
    public override func awakeFromInsert() {
        
        // when its created asign the current date to the attribute "created"
        // this func make it happen every time
        super.awakeFromInsert()
        self.created = NSDate()
        
    }
    
}
