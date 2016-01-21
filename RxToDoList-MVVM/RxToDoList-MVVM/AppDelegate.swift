//
//  AppDelegate.swift
//  RxToDoList-MVVM
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 21..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
     
        let coreDataStack = CoreDataStack()
        coreDataStack.loadFirstTimeData()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            let mainViewModel = MainViewModel(coreDataStack: coreDataStack)
            let mainViewController = MainViewController(viewModel: mainViewModel)
            let navigationController = UINavigationController(rootViewController: mainViewController)
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        return true
    }
}

