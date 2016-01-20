//
//  ViewController.swift
//  RxImagePicker
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 20..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var cameraButton : UIButton!
    @IBOutlet weak var galleryButton : UIButton!
    @IBOutlet weak var cropButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        cameraButton.rx_tap
            .flatMapLatest { [unowned self] _ in
                return UIImagePickerController.rx_createWithParent(self) { picker in
                    picker.sourceType = .Camera
                    picker.allowsEditing = false
                    picker.rx_didCancel
                        .subscribeNext {
                            picker.dismissViewControllerAnimated(true, completion: nil)
                        }
                        .addDisposableTo(self.disposeBag)
                }
                .flatMap { $0.rx_didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .bindTo(imageView.rx_image)
            .addDisposableTo(disposeBag)
        
        
        galleryButton.rx_tap
            .flatMapLatest { [unowned self] _ in
                return UIImagePickerController.rx_createWithParent(self) { picker in
                    picker.sourceType = .PhotoLibrary
                    picker.allowsEditing = false
                    picker.rx_didCancel
                        .subscribeNext {
                            picker.dismissViewControllerAnimated(true, completion: nil)
                        }
                        .addDisposableTo(self.disposeBag)
                }
                .flatMap { $0.rx_didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .bindTo(imageView.rx_image)
            .addDisposableTo(disposeBag)
        
        
        cropButton.rx_tap
            .flatMapLatest { [unowned self] _ in
                return UIImagePickerController.rx_createWithParent(self) { picker in
                    picker.sourceType = .PhotoLibrary
                    picker.allowsEditing = true
                    picker.rx_didCancel
                        .subscribeNext {
                            picker.dismissViewControllerAnimated(true, completion: nil)
                        }
                    .addDisposableTo(self.disposeBag)
                }
                .flatMap { $0.rx_didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[UIImagePickerControllerEditedImage] as? UIImage
            }
            .bindTo(imageView.rx_image)
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

