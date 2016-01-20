//
//  ViewController.swift
//  RxTableView
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 20..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        
        items
            .bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { (row, data, cell) in
                cell.textLabel?.text = "Hello \(data)"
            }
            .addDisposableTo(disposeBag)
    
        tableView
            .rx_modelSelected(Int)
            .subscribeNext { value in
                
                let alert = UIAlertView(title: "Clicked", message: "Hello \(value)", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
            }
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

