//
//  NSManagedObject+RxSwift.swift
//  RxToDoList-MVVM
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 21..
//  Copyright © 2016년 burt. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

extension NSManagedObjectContext {
    var rx_contextSaved: Observable<NSNotification> {
        get {
            return NSNotificationCenter.defaultCenter()
                .rx_notification(NSManagedObjectContextDidSaveNotification)
        }
    }
}