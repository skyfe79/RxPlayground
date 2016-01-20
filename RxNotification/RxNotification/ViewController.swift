//
//  ViewController.swift
//  RxNotification
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 20..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // receive
        NSNotificationCenter.defaultCenter().rx_notification("testNotification")
        .subscribeNext { (notification) -> Void in
            
            
            if let o = notification.object {
                print(notification.name + " with object" + String(o))
            } else {
                print(notification.name + " without obect")
            }
        }
        .addDisposableTo(disposeBag)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // send
        NSNotificationCenter.defaultCenter().postNotificationName("testNotification", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("testNotification", object: NSObject())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

