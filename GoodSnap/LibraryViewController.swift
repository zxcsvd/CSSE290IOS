//
//  LibraryViewController.swift
//  GoodSnap
//
//  Created by Ruying Chen on 1/31/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

import UIKit
import CoreData

class LibraryViewController: UITableViewController, NSFetchedResultsControllerDelegate  {
    
    var managedObjectContext : NSManagedObjectContext? = nil
    var selectedRow : NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    var libraryTitle : String = ""
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tabBarButton: UIButton!

    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.frame = CGRectMake(0, 0, 30, 30)
        tabBarButton.frame = CGRectMake(0, 0, 35, 35)
        
        //NavBar.barTintColor = UIColor.greenColor()
        self.navigationController?.navigationBar.barTintColor = UIColorFromRGB(0xA4D9CC)
        if self.libraryTitle == "" {
            self.libraryTitle = "Untitled ShoppingList"
        }
        self.navigationController!.navigationBar.topItem?.title = self.libraryTitle
        println("self.navigationController?.navigationBar.topItem?.title : \(self.navigationController?.navigationBar.topItem?.title)")
        
        // Do any additional setup after loading the view, typically from a nib
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewWillAppear")
        self.tableView.reloadData()
    }
    
    @IBAction func AddNewList(sender: AnyObject) {
        let alertController = UIAlertController(title: "Create a new Item", message: "", preferredStyle: .Alert)

        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Brand"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action) -> Void in
            // println("You pressed Cancel")
        }
        
        let createAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            // println("Yoeatherpicu Pressed Create Quote")
            let nameTextField = alertController.textFields![0] as UITextField
            let brandTextField = alertController.textFields![1] as UITextField
            if brandTextField.text == "" {
                brandTextField.text = "unknonw"
            }
            
            let newItem = NSEntityDescription.insertNewObjectForEntityForName("Goods", inManagedObjectContext: self.managedObjectContext!) as Goods
            newItem.name = nameTextField.text
            newItem.brand = brandTextField.text
            newItem.type = "unknown"
            newItem.barcode = "unknown"
            newItem.itemDescription = "N/A"
            
            self.saveManagedObjectContext()
            
        }

        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func MenuList(sender: AnyObject) {
        
        var segue: UIStoryboardSegue
        
        let actionSheet = UIAlertController(title: "I want to  ", message:"", preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        let GotoShoppingListAction = UIAlertAction(title: "Choose another ShoppingList", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            self.performSegueWithIdentifier("goToShoppingList", sender: self)
            println("GotoShoppingList")
        }
        
        let GotoCartAction = UIAlertAction(title: "go to Cart of the ShoppList", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            self.performSegueWithIdentifier("goToCart", sender: self)
            println("GotoCart")
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action) -> Void in
            
        }
        
        actionSheet.addAction(GotoShoppingListAction)
        actionSheet.addAction(GotoCartAction)
        actionSheet.addAction(CancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var itemCount : Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
    func getItemAtIndexPath(indexPath : NSIndexPath) -> Goods {
        return fetchedResultsController.objectAtIndexPath(indexPath) as Goods
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(itemCount,1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if itemCount == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("NoLibraryItem", forIndexPath: indexPath) as UITableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("LibraryItem", forIndexPath: indexPath) as UITableViewCell
            let item =  getItemAtIndexPath(indexPath)
            cell.textLabel.text = item.name
            cell.detailTextLabel?.text = item.brand
        }
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
/*    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let lst =  getItemAtIndexPath(indexPath)
        println("You just click on \(lst.name)")
    }
*/
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return itemCount > 0
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if itemCount == 0 {
            super.setEditing(false, animated: animated)
        } else {
            super.setEditing(editing, animated: animated)
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //Do something
            let itemToDelete =  self.getItemAtIndexPath(indexPath)
            self.managedObjectContext?.deleteObject(itemToDelete)
            self.saveManagedObjectContext()
            
        })
        delete.backgroundColor = UIColorFromRGB(0xE6604A)
        
        // put re-setting name/brand/description inside of DetailInfoViewConroller
        var info = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Info" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //Do something
            self.selectedRow = indexPath
            self.performSegueWithIdentifier("showDetail", sender: self)
            
            
        })
        info.backgroundColor = UIColorFromRGB(0xF6E2A0)
        
        var toCart = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Cart" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //Do something
            
            self.selectedRow = indexPath
            self.performSegueWithIdentifier("putIntoCart", sender: self)
            
        })
        toCart.backgroundColor = UIColorFromRGB(0x00CDA9)
        
        return [delete, info, toCart]
    }
    

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
     @IBAction func rightNavItemEditClick() {
        self.performSegueWithIdentifier("goToTabBar", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let item = getItemAtIndexPath(self.selectedRow)
            let detailVC = segue.destinationViewController as DetailViewController
            detailVC.item = item
            detailVC.managedObjectContext =  managedObjectContext
        }
        
        if segue.identifier == "goToShoppingList" {
            let listVC = segue.destinationViewController as ListViewController
            listVC.managedObjectContext =  managedObjectContext
        }
        
        if segue.identifier == "goToCart" {
            let cartVC = segue.destinationViewController as CartViewController
            cartVC.managedObjectContext =  managedObjectContext
        }
        
        if segue.identifier == "putIntoCart" {
            let item = getItemAtIndexPath(self.selectedRow)
            let cartVC = segue.destinationViewController as CartViewController
            cartVC.managedObjectContext =  managedObjectContext
            cartVC.addNewCartItem(item)
            
            //let cell = tableView.dequeueReusableCellWithIdentifier("LibraryItem", forIndexPath: self.selectedRow) as UITableViewCell
            //cell.hidden = true
            
            self.managedObjectContext?.deleteObject(item)
            self.saveManagedObjectContext()
            //self.viewWillAppear(true)
        }
    }
    
    func addNewLibraryItem(itemToAdd : Cart) {
        
        println(2)
        
        let newCartItem = NSEntityDescription.insertNewObjectForEntityForName("Goods", inManagedObjectContext: self.managedObjectContext!) as Goods
        newCartItem.name = itemToAdd.name
        newCartItem.brand = itemToAdd.brand
        newCartItem.type = itemToAdd.type
        newCartItem.barcode = itemToAdd.barcode
        newCartItem.itemDescription = itemToAdd.itemDescription
        self.saveManagedObjectContext()
        
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
        
        let fetchRequest = NSFetchRequest(entityName: "Goods")
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastTouchDate", ascending: false)]
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
            if (itemCount == 1) {
                tableView.reloadData()
            } else {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
            
        case .Delete:
            if (itemCount == 0) {
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