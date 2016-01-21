//
//  AddViewModel.swift
//  RxToDoList-MVVM
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 21..
//  Copyright © 2016년 burt. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxViewModel
class AddViewModel : RxViewModel {
    
    // input
    var contentTextObservable = Variable("")
    
    // output
    let cancelBarButtonItemTitle = "Cancel"
    let doneBarButtonItemTitle = "Done"
    var contentValid: Observable<Bool>
    
    
    // private
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.contentValid = Observable.never()
        super.init()
        
        contentValid = contentTextObservable
            .asObservable()
            .flatMap { text in
                Observable.just(text.characters.count != 0 ? true : false)
            }
            .shareReplay(1)
    }
    
    func addItem() {
        let item = NSEntityDescription.insertNewObjectForEntityForName(Item.entityName, inManagedObjectContext: coreDataStack.context) as! Item
        item.content = contentTextObservable.value
        item.done = false
        
        do {
            try coreDataStack.context.save()
        } catch {
            print("Failed to save to CoreData")
        }
    }
}