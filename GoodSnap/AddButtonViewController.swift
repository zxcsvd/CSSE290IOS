//
//  AddButtonViewController.swift
//  GoodSnap
//
//  Created by Bo Peng on 2/15/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

import UIKit

class AddButtonViewController: UITabBarController {
    //var goods = [NSManagedObject]()
    @IBAction func clickedToadd(sender: AnyObject) {
        
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        //5
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
