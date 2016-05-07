//
//  CartViewController.swift
//  GoodSnap
//
//  Created by Ruying Chen on 2/5/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext? = nil
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBOutlet weak var libraryButton: UIButton!
    
    var selectedRow : NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    var listCount : Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
    func getItemAtIndexPath(indexPath : NSIndexPath) -> Cart {
        return fetchedResultsController.objectAtIndexPath(indexPath) as Cart
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NavBar.barTintColor = UIColor.greenColor()
        self.navigationController?.navigationBar.barTintColor = UIColorFromRGB(0xA4D9CC)
        // Do any additional setup after loading the view, typically from a nib.
        libraryButton.frame = CGRectMake(16, 7, 30, 30)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewCartItem(itemToAdd : Goods) {

        let newCartItem = NSEntityDescription.insertNewObjectForEntityForName("Cart", inManagedObjectContext: self.managedObjectContext!) as Cart
        newCartItem.name = itemToAdd.name
        newCartItem.brand = itemToAdd.brand
        newCartItem.type = itemToAdd.type
        newCartItem.barcode = itemToAdd.barcode
        newCartItem.itemDescription = itemToAdd.itemDescription
        newCartItem.isChecked = false
        self.saveManagedObjectContext()
            
    
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(listCount,1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        if listCount == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("NoCartItem", forIndexPath: indexPath) as UITableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("CartItem", forIndexPath: indexPath) as UITableViewCell
            let citem =  getItemAtIndexPath(indexPath)
            
            if citem.isChecked == true {
                let strikeThroughAttributes = [NSStrikethroughStyleAttributeName : 1]
                let strikeThroughString = NSAttributedString(string: citem.name, attributes: strikeThroughAttributes)
                cell.textLabel.attributedText = strikeThroughString
            } else {
                let plainString = NSAttributedString(string: citem.name)
                cell.textLabel.attributedText = plainString
                cell.detailTextLabel?.text = citem.brand
            }
        }
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if listCount > 0 {
            let citem =  getItemAtIndexPath(indexPath)
            if citem.isChecked == true {
                citem.isChecked = false
            } else {
                citem.isChecked = true
            }
        
            self.saveManagedObjectContext()
            viewWillAppear(true)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return listCount > 0
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if listCount == 0 {
            super.setEditing(false, animated: animated)
        } else {
            super.setEditing(editing, animated: animated)
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var remove = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remove" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //Do something
            let itemToDelete =  self.getItemAtIndexPath(indexPath)
            
            self.selectedRow = indexPath
            self.performSegueWithIdentifier("removeBack", sender: self)
            
        })
        remove.backgroundColor = UIColorFromRGB(0xE6604A)
        
        var info = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Info" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //Do something
            self.selectedRow = indexPath
            self.performSegueWithIdentifier("showDetailFromCart", sender: self)
            
        })
        info.backgroundColor = UIColorFromRGB(0xF6E2A0)
        
        return [remove, info]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewWillAppear")
        tableView.reloadData()
        viewDidLoad()
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.viewWillAppear(true)
    }
    
    @IBAction func deleteAll() {
        var cell : UITableViewCell
        
        if listCount != 0 {
            var i : NSIndexPath
            var row : Int

            for (row = (listCount - 1); row >= 0; row--) {
                
                i = NSIndexPath(forRow: row, inSection: 0)
                let itemToDelete =  self.getItemAtIndexPath(i)
                cell = tableView.dequeueReusableCellWithIdentifier("CartItem", forIndexPath: i) as UITableViewCell
                cell.textLabel.text = ""
                cell.detailTextLabel?.text = ""
                self.performSegueWithIdentifier("removeBack", sender: self)


            }
            cell = tableView.dequeueReusableCellWithIdentifier("NoCartItem", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell
            
            viewWillAppear(true)
        }

    }

    @IBAction func backToLibrary(sender: AnyObject) {
        self.performSegueWithIdentifier("cartBackToLibrary", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "cartBackToLibrary" {
            let detailVC = segue.destinationViewController as LibraryViewController
            detailVC.managedObjectContext =  managedObjectContext
        }
        
        if segue.identifier == "showDetailFromCart" {
            let item = getItemAtIndexPath(self.selectedRow)
            
            let detailVC = segue.destinationViewController as DetailFromCartViewController
            
            detailVC.item = item
            detailVC.managedObjectContext =  managedObjectContext

        }
        
        if segue.identifier == "removeBack" {
            println(1)
            let item = getItemAtIndexPath(self.selectedRow)
            let LibraryVC = segue.destinationViewController as LibraryViewController
            LibraryVC.managedObjectContext =  managedObjectContext
            LibraryVC.addNewLibraryItem(item)
            self.managedObjectContext?.deleteObject(item)
            self.saveManagedObjectContext()

            //self.viewWillAppear(true)
        }

    }

    
    func saveManagedObjectContext() {
        var error: NSError? = nil
        managedObjectContext!.save(&error)
        if error != nil {
            println("Unresolved Core Data error \(error?.userInfo)")
            abort()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Cart")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.fetchBatchSize = 20
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "GoodSnapCache")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        _fetchedResultsController!.performFetch(&error)
        if error != nil {
            println("Unresolved Core Data error \(error?.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if (listCount == 1) {
                tableView.reloadData()
            } else {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
            
        case .Delete:
            if (listCount == 0) {
                tableView.reloadData()
                setEditing(false, animated: true)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            }
            
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}