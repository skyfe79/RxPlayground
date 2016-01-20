//
//  ViewController.swift
//  RxAlamorefire
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 20..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var txtView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getButton.rx_tap
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribeNext { [unowned self] in
                
                self.request()
                
            }
            .addDisposableTo(disposeBag)
        
        txtView.rx_text
            .subscribeNext { txt in
                print(txt)
            }
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func request() {
        requestString(Alamofire.Method.GET , "http://www.daum.net")
            .debug()
            .subscribeNext { [unowned self] (response, result) -> Void in
                self.txtView.text = result
            }
            .addDisposableTo(disposeBag)
        
    }
}

