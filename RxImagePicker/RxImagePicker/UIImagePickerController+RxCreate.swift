//
//  UIImagePickerController+RxCreate.swift
//  RxImagePicker
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 20..
//  Copyright © 2016년 burt. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

func dismissViewController(viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed() || viewController.isBeingPresented() {
        dispatch_async(dispatch_get_main_queue()) {
            dismissViewController(viewController, animated: animated)
        }
        return
    }
    
    if viewController.presentationController != nil {
        viewController.dismissViewControllerAnimated(animated, completion: nil)
    }
}

extension UIImagePickerController {
    
    static func rx_createWithParent(parent: UIViewController?, animated: Bool = true,
        configureImagePicker: (UIImagePickerController) throws -> () = { x in }) -> Observable<UIImagePickerController> {
        
            return Observable.create { [weak parent] observer in
                let imagePicker = UIImagePickerController()
                do {
                    try configureImagePicker(imagePicker)
                } catch let error {
                    observer.on(.Error(error))
                    return NopDisposable.instance
                }
                
                guard let parent = parent else {
                    observer.on(.Completed)
                    return NopDisposable.instance
                }
                
                parent.presentViewController(imagePicker, animated: animated, completion: nil)
                observer.on(.Next(imagePicker))
                
                return AnonymousDisposable {
                    dismissViewController(imagePicker, animated: animated)
                }
                
            }
    }
}