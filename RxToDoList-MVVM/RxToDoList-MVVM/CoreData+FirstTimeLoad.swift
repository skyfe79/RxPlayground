//
//  CoreData_FirstTimeLoad.swift
//  RxToDoList-MVVM
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 21..
//  Copyright © 2016년 burt. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataStack {
    func loadFirstTimeData() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard (userDefaults.boolForKey("firstTimeDataLoaded") == false) else {
            return
        }
        
        userDefaults.setBool(true, forKey: "firstTimeDataLoaded")
        
        for (index, itemContent) in ["Walk out dog", "Wash Car"].enumerate() {
            let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
            item.content = itemContent
            item.position = index
            item.done = false
        }
        
        do {
            try context.save()
        } catch {
            print("failed to save to CorData")
        }
    }
}