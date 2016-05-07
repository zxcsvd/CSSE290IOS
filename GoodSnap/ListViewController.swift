//
//  ListViewController.swift
//  GoodSnap
//
//  Created by Ruying Chen on 2/1/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext? = nil
    var selectedRow : NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    @IBOutlet weak var libraryButton: UIButton!
    
    var listCount : Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
    func getListAtIndexPath(indexPath : NSIndexPath) -> ShoppingList {
        return fetchedResultsController.objectAtIndexPath(indexPath) as ShoppingList
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getItemAtIndexPath(indexPath : NSIndexPath) -> ShoppingList {
        return fetchedResultsController.objectAtIndexPath(indexPath) as ShoppingList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        libraryButton.frame = CGRectMake(16, 7, 30, 30)
        
        //NavBar.barTintColor = UIColor.greenColor()
        self.navigationController?.navigationBar.barTintColor = UIColorFromRGB(0xA4D9CC)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func AddNewList(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Create a new ShoppingList", message: "", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action) -> Void in
            // println("You pressed Cancel")
        }
        
        let createAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            // println("Yoeatherpicu Pressed Create Quote")
            let nameTextField = alertController.textFields![0] as UITextField
            
            let newList = NSEntityDescription.insertNewObjectForEntityForName("ShoppingList", inManagedObjectContext: self.managedObjectContext!) as ShoppingList
            newList.name = nameTextField.text
            self.saveManagedObjectContext()
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(listCount,1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if listCount == 0 {
            
            let newList = NSEntityDescription.insertNewObjectForEntityForName("ShoppingList", inManagedObjectContext: self.managedObjectContext!) as ShoppingList
            newList.name = "Untitled ShoppingList"
            self.saveManagedObjectContext()
            
        }
        
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ShoppingListItem", forIndexPath: indexPath) as UITableViewCell
        
        let lst =  getListAtIndexPath(indexPath)
        cell.textLabel.text = lst.name
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath
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
        
        var delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //Do something
            let listToDelete =  self.getListAtIndexPath(indexPath)
            self.managedObjectContext?.deleteObject(listToDelete)
            self.saveManagedObjectContext()

        })
        delete.backgroundColor = UIColorFromRGB(0xE6604A)
        
        var rename = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Rename" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //Do something
            self.renameShoppimgList(indexPath)
            self.viewWillAppear(true)

        })

        rename.backgroundColor = UIColorFromRGB(0xEFA184)
        
        return [delete, rename]
    }
    
    func renameShoppimgList(indexPath: NSIndexPath) {
        let listToRename =  self.getListAtIndexPath(indexPath)
        let alertController = UIAlertController(title: "Rename", message: "", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = listToRename.name
            textField.placeholder = "name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            println("Cancel")
        }
        let defaultAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.Default) { (action) -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            listToRename.name = nameTextField.text
            listToRename.lastTouchDate = NSDate()
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ShoppingListItem", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel.text = nameTextField.text
            self.saveManagedObjectContext()
            self.viewWillAppear(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        println("listToRename.name: \(listToRename.name)")
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewWillAppear")
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.viewWillAppear(true)
    }
    
    @IBAction func backToLibrary(sender: AnyObject) {
        self.performSegueWithIdentifier("listBackToLibrary", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "listBackToLibrary" {
            let list = getItemAtIndexPath(self.selectedRow)
            let libraryVC = segue.destinationViewController as LibraryViewController
            libraryVC.libraryTitle = list.name
            libraryVC.managedObjectContext =  managedObjectContext
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
        
        let fetchRequest = NSFetchRequest(entityName: "ShoppingList")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastTouchDate", ascending: false)]
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