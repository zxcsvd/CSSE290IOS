//
//  DetailViewController.swift
//  GoodSnap
//
//  Created by Ruying Chen on 2/9/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    //@IBOutlet weak var WeatherpicImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    var managedObjectContext : NSManagedObjectContext?
    var item : Goods?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "showEditDialog")
        println(item?.description)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.text = self.item?.name
        self.brandLabel.text = self.item?.brand
        self.typeLabel.text = self.item?.type
        self.barcodeLabel.text = self.item?.barcode
        self.descriptionLabel.text = self.item?.itemDescription

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func showEditDialog() {
        
        let alertController = UIAlertController(title: "Edit", message: "", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = self.item?.name
            textField.placeholder = "Name"
        }
       
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = self.item?.brand
            textField.placeholder = "Brand"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
        
            textField.text = self.item?.type
            textField.placeholder = "Type"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            println("Cancel")
        }
        
        let defaultAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let nameTextField = alertController.textFields![0] as UITextField
            self.item?.name = nameTextField.text

            let brandTextField = alertController.textFields![1] as UITextField
            self.item?.brand = brandTextField.text
            
            let typeTextField = alertController.textFields![2] as UITextField
            self.item?.type = typeTextField.text
            
            var error: NSError? = nil
            self.managedObjectContext!.save(&error)
            if error != nil {
                println("Unresolved Core Data error \(error?.userInfo)")
            }
            
            self.nameLabel.text = self.item?.name
            self.brandLabel.text = self.item?.brand
            self.typeLabel.text = self.item?.type
        }
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    @IBAction func editDescription(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: "Edit Description", message: "", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = self.item?.itemDescription
            textField.placeholder = "Description"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            println("Cancel")
        }
        
        let defaultAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let descriptionTextField = alertController.textFields![0] as UITextField
            self.item?.itemDescription = descriptionTextField.text
            
            var error: NSError? = nil
            self.managedObjectContext!.save(&error)
            if error != nil {
                println("Unresolved Core Data error \(error?.userInfo)")
            }
            
            self.descriptionLabel.text = self.item?.itemDescription

        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }

}
