//
//  ViewController.swift
//  RxLocation
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 20..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self; // optional setting
        setupCoreLocationObserver()
        
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func setupCoreLocationObserver() {
        locationManager.rx_didUpdateLocations
            .subscribeNext{ location in
                print(location)
            }
            .addDisposableTo(disposeBag)
        
        locationManager.rx_didFailWithError
            .subscribeNext { (error) -> Void in
                print(error)
            }
            .addDisposableTo(disposeBag)
        
        locationManager.rx_didChangeAuthorizationStatus
            .subscribeNext { (status) -> Void in
                print(status)
            }
            .addDisposableTo(disposeBag)
    }
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("propagation loction" + String(locations[0]))
    }
}

