//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Caroline Davis on 13/04/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    var stores = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // replacing the back button at the top to not put "Dream Lister"
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
    
//        // creating store entities for coredata
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context: context)
//        store3.name = "Frys Electronics"
//        let store4 = Store(context: context)
//        store4.name = "Target"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "Kmart"
//        
//        ad.saveContext()
        
        getStores()
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        return store.name
        
    }
    
    // how many rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }

    // how many collumns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected
    }
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
           self.stores = try context.fetch(fetchRequest)
            //reloads data for the picker
            self.storePicker.reloadAllComponents()
            
        } catch {
            // handle the error
        }
        
    }

    @IBAction func savePressed(_ sender: UIButton) {
            
        let item = Item(context: context)
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            
            item.price = (price as NSString).doubleValue
            
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        // which column its in = 0 cos there is only one
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        // the -= is new syntax for the popview controller
        _ = navigationController?.popViewController(animated: true)
        
            
    }
        
    
    

}
