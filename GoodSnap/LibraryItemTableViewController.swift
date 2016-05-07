//
//  File.swift
//  GoodSnap
//
//  Created by Ruying Chen on 2/5/15.
//  Copyright (c) 2015 Ruying Chen. All rights reserved.
//

import UIKit

class LibraryItemTableViewController: UITableView {
    
    class Item: NSObject {
        let name: String
        var section: Int?
    
        init(name: String) {
            self.name = name
        }
    }

    // custom type to represent table sections
    class Section {
        var items: [Item] = []
    
        func addUser(addItem: Item) {
            self.items.append(addItem)
        }
    }

    // raw user data
    let names = [
        "Clementine",
        "Bessie",
        "Yolande",
        "Tynisha",
        "Ellyn",
        "Trudy",
        "Fredrick",
        "Letisha",
        "Ariel",
        "Bong",
        "Jacinto",
        "Dorinda",
        "Aiko",
        "Loma",
        "Augustina",
        "Margarita",
        "Jesenia",
        "Kellee",
        "Annis",
        "Charlena"
    ]

    // `UIKit` convenience class for sectioning a table
    let collation = UILocalizedIndexedCollation.currentCollation()
        as UILocalizedIndexedCollation

    // table sections
    var sections: [Section] {
        // return if already initialized
        if self._sections != nil {
            return self._sections!
        }
    
        // create users from the name list
        var items: [Item] = names.map { name in
            var user = Item(name: name)
            user.section = self.collation.sectionForObject(user, collationStringSelector: "name")
            return user
        }
    
        // create empty sections
        var sections = [Section]()
        for i in 0..<self.collation.sectionIndexTitles.count {
            sections.append(Section())
        }
    
        // put each user in a section
        for item in items {
            sections[item.section!].addUser(item)
        }
    
        // sort each section
        for section in sections {
            section.items = self.collation.sortedArrayFromArray(section.items, collationStringSelector: "name") as [Item]
        }
    
        self._sections = sections
    
        return self._sections!
    
    }
    
    var _sections: [Section]?

// table view data source

func numberOfSectionsInTableView(tableView: UITableView)
    -> Int {
        return self.sections.count
}

func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int)
    -> Int {
        return self.sections[section].items.count
}

func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {
        let item = self.sections[indexPath.section].items[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LibrayItem", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = item.name
        return cell
}

/* section headers
appear above each `UITableView` section */
func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int)
    -> String {
        // do not display empty `Section`s
        if !self.sections[section].items.isEmpty {
            return self.collation.sectionTitles[section] as String
        }
        return ""
}

/* section index titles
displayed to the right of the `UITableView` */
func sectionIndexTitlesForTableView(tableView: UITableView)
    -> [AnyObject] {
        return self.collation.sectionIndexTitles
}

func tableView(tableView: UITableView,
    sectionForSectionIndexTitle title: String,
    atIndex index: Int)
    -> Int {
        return self.collation.sectionForSectionIndexTitleAtIndex(index)
}
}