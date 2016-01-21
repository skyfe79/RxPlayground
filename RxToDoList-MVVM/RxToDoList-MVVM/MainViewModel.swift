//
//  MainViewModel.swift
//  RxToDoList-MVVM
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 21..
//  Copyright © 2016년 burt. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class MainViewModel: RxViewModel {
    
    // Input
    var searchTextObservable = PublishSubject<String>()
    
    // Output
    var contentChangesObservable: Observable<[Item]>
    var titleObservable: Observable<String>
    
    
    private var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        contentChangesObservable = Observable.never()
        titleObservable = Observable.never()
        super.init()
        
        contentChangesObservable = Observable.of(didBecomeActive.map { _ in "" }, searchTextObservable)
            .merge()
            .map { text in
                if text.characters.count == 0 {
                    return MainViewModel.getItemsWithStack(coreDataStack)
                } else {
                    let fetchRequest = NSFetchRequest(entityName: Item.entityName)
                    fetchRequest.predicate = NSPredicate(format: "content CONTAINS[cd] %@", text)
                    return try! self.coreDataStack.context.executeFetchRequest(fetchRequest) as! [Item]
                }
            }
            .shareReplay(1)
        
        titleObservable = contentChangesObservable
            .map {
                $0.count
            }
            .map {
                $0 == 0 ? "Nothing to do" : "\($0)"
            }
            .shareReplay(1)
    }
    
    func addViewModel() -> AddViewModel {
        return AddViewModel(coreDataStack: coreDataStack)
    }
}

extension MainViewModel {
    private static func getItemsWithStack(stack: CoreDataStack) -> [Item] {
        return try! stack.context.executeFetchRequest(NSFetchRequest(entityName: Item.entityName)) as! [Item]
    }
}