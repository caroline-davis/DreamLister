//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Caroline Davis on 13/04/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var typeField: CustomTextField!
    @IBOutlet weak var thumbImage: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    var type: ItemType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // replacing the back button at the top to not put "Dream Lister"
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    
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
        
        if itemToEdit != nil {
            loadItemData()
        }
    
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
            
        var item: Item!
        
        let picture = Image(context: context)
        picture.image = thumbImage.image
        // added in
        let category = ItemType(context: context)
        category.type = typeField.text
        

        
        // checks to see if it will update existing cell instead of just making a new one
        if itemToEdit == nil {
            
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        item.toImage = picture
        // added in
        item.toItemType = category
        
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
    
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            // load the TYPE in here
            typeField.text = item.toItemType?.type
            
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
            }
            
        }
        
    }
    
    // deletes item off
    @IBAction func deletePressed(_ sender: AnyObject) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
   
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // adds the image and abilty to get an image. in the plist added a privacy photos line
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // have to get the image out of the dictionary
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            thumbImage.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
