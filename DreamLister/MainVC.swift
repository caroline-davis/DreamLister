//
//  MainVC.swift
//  DreamLister
//
//  Created by Caroline Davis on 11/04/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // we are fetching the "Item" dataclasses which is in the xdatamodel
    var controller: NSFetchedResultsController<Item>!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // generateTestData()
        attemptFetch()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
    }
    
    // when the item is clicked this func is called
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // checking there is at least 1 item in the controller
        // instead of the objects = controller.fetchedObjects where objects.count > 0
        if let objects = controller.fetchedObjects, objects.count > 0 {
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    // rows are always 150 height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        // you can sort by a property in a relationship by using "relationship.property"
        let typeSort = NSSortDescriptor(key: "toItemType.type", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        } else if segment.selectedSegmentIndex == 3 {
            fetchRequest.sortDescriptors = [typeSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // important so the methods know what controller to delegate stuff to etc.
        controller.delegate = self
        
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func segmentChange(_ sender: AnyObject) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    // boiler plate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // boiler plate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // has the standard enum for tableviews :)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            // when creating a new item, it just adds it in
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            // deletes the selected row
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                // update the cell data.
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        
        }
        
    }
    
    func generateTestData() {
        
        let item = Item(context: context)
        let itemType = ItemType(context: context)
        
        itemType.type = "Computerly"
        
        item.toItemType = itemType
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until the September event, I hope they release new MBPs"

        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "I want to block out everyone, they are annoying"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "I will have this one day"
        
        // saves the data! sweeeeet
        ad.saveContext()
    }
    
}





















