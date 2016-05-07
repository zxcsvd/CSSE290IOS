//
//  TypeSearchViewController.swift
//  GoodSnap
//
//  Created by Ruying Chen on 2/5/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

import UIKit
import CoreData

class TypeSearchViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, NSFetchedResultsControllerDelegate {
    
    let alertController = UIAlertController(title: "Add a new Value", message: "", preferredStyle: .Alert)
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    @IBOutlet weak var searchBarView: UISearchBar!
    var result = 0
    var goods = [NSManagedObject]()
    var filteredGoods = [NSManagedObject]()
    var managedObjectContext : NSManagedObjectContext? = nil
    var array = [""]
    
    override func viewDidLoad() {
        //        print("xxx")
        
        
        //        var leftNavBarButton = UIBarButtonItem(customView:searchBarView)
        //        self.navigationItem.leftBarButtonItem = leftNavBarButton
        //self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem.
        searchBarView.autocapitalizationType = .None
        self.tableView.reloadData()
    }
    
//    @IBAction func AddInformationButton(sender: AnyObject) {
//        self.showAddGoodsDialog()
//        
//    }
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            if tableView == self.searchDisplayController!.searchResultsTableView {
                return self.filteredGoods.count
            } else {
                return self.goods.count
            }
            //return goods.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SearchResults") as UITableViewCell
        var good: NSManagedObject
        if tableView == self.searchDisplayController!.searchResultsTableView {
            good = filteredGoods[indexPath.row]
        } else {
            good = goods[indexPath.row]
        }
        cell.textLabel.text = good.valueForKey("name") as String?
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        //            let good = goods[indexPath.row]
        //            cell.textLabel!.text = good.valueForKey("name") as String?
        //            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    
    
    //    let saveAction = UIAlertAction(title: "Save",
    //        style: .Default) { (action: UIAlertAction!) -> Void in
    //
    //            let textField = alert.textFields![0] as UITextField
    //            self.saveName(textField.text)
    //            self.tableView.reloadData()
    //    }
    
    
    func saveName(name: String, brand: String, type: String, barcode : String ) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Goods",
            inManagedObjectContext:
            managedContext)
        
        let good = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        good.setValue(name, forKey: "name")
        good.setValue(brand, forKey: "brand")
        good.setValue("", forKey: "itemDescription")
        good.setValue(type, forKey: "type")
        good.setValue(barcode, forKey: "barcode")
        
        //4
//        var error: NSError?
//        if !managedContext.save(&error) {
//            println("Could not save \(error), \(error?.userInfo)")
//        }
        //5
        goods.append(good)
        //self.tableView.reloadData()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Goods")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            goods = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
//        if(goods.count == 0){
//            self.saveName("aaabbbb", brand: "", type: "", barcode: "")
//            self.saveName("aabbb", brand: "", type: "", barcode: "")
//            self.saveName("cccaa", brand: "", type: "", barcode: "")
//        }
    }
    
    func showAddGoodsDialogBar() -> UIAlertController{
        
        let alertController = UIAlertController(title: "Create a new goods", message: "", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in textField.placeholder = "Name"}
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in textField.placeholder = "Brand" }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in textField.placeholder = "Type" }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            // println("You pressed Cancel") 
        }
        
        let createGoods = UIAlertAction(title: "Add Goods", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            // println("You Pressed Create Quote")
            let nameTextField = alertController.textFields![0] as UITextField
            let brandTextField = alertController.textFields![1] as UITextField
            let typeTextField = alertController.textFields![2] as UITextField
            self.array = [nameTextField.text, brandTextField.text, typeTextField.text]

        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createGoods)
        return alertController
        //presentViewController(alertController, animated: true, completion: nil)
        //return array
    }
    
    
    
    
    
    func showAddGoodsDialog() {
        let alertController = UIAlertController(title: "Create a new goods", message: "", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Brand"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Type"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (action) -> Void in
            // println("You pressed Cancel")
        }
        
        let createGoods = UIAlertAction(title: "Add Goods", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            // println("You Pressed Create Quote")
            let nameTextField = alertController.textFields![0] as UITextField
            let brandTextField = alertController.textFields![1] as UITextField
            let typeTextField = alertController.textFields![2] as UITextField
            //self.movieQuotes.insert(MovieQuote(quote: quoteTextField.text, movie: movieTextField.text), atIndex: 0)
            
            //            let newGoodsInfo = NSEntityDescription.insertNewObjectForEntityForName("Goods", inManagedObjectContext: self.managedObjectContext!) as Goods
            
            
            self.saveName(nameTextField.text, brand: brandTextField.text, type: typeTextField.text, barcode: "")

        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createGoods)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func saveManagedObjectContext() {
        var error: NSError? = nil
        managedObjectContext!.save(&error)
        if error != nil {
            println("Unresolved Core Data error \(error?.userInfo)")
            abort()
        }
    }
    
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredGoods = self.goods.filter({( good: NSManagedObject) -> Bool in
            //let categoryMatch = (scope == "All") || (good.category == scope)
            var tempString = good.valueForKey("name") as String
            
            var stringMatch =  tempString.rangeOfString(searchText)
            var match = (stringMatch != nil)
            let s = tempString + " " + match.description + " " + searchText
            println(s)
            return  (stringMatch != nil)
        })
        if (self.filteredGoods.count == 0){
            self.showAddGoodsDialog()
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        println("search")
        
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        println("search2")
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("searchDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "searchDetail" {
            let searchDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredGoods[indexPath.row].valueForKey("name") as String
                searchDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.goods[indexPath.row].valueForKey("name") as String
                searchDetailViewController.title = destinationTitle
            }
        }
        
        
        

    }
    
    

}