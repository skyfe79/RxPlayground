//
//  AddViewController.swift
//  RxToDoList-MVVM
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 21..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddViewController: UIViewController {
    
    var viewModel: AddViewModel
    
    let textView = UITextView()
    let cancelBarButtonItem = UIBarButtonItem()
    let doneBarButtonItem = UIBarButtonItem()
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: AddViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("initWithCoder not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindViewModel()
    }
    
    func bindViewModel() {
        cancelBarButtonItem.title = viewModel.cancelBarButtonItemTitle
        doneBarButtonItem.title = viewModel.doneBarButtonItemTitle
        
        _ = textView.rx_text.bindTo(viewModel.contentTextObservable)
        
        _ = self.viewModel.contentValid.bindTo(doneBarButtonItem.rx_enabled)
        
        _ = doneBarButtonItem.rx_tap.subscribeNext { [unowned self] _ in
            self.viewModel.addItem()
            self.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        _ = cancelBarButtonItem.rx_tap.subscribeNext { [unowned self] _ in
            self.dismissViewControllerAnimated(true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }
    
    func initUI() {
        let views = [
            "textView" : textView
        ]
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[textView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[textView]|", options: [], metrics: nil, views: views))
        
        textView.becomeFirstResponder()
        
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
}





