//
//  MainViewController.swift
//  RxToDoList-MVVM
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 21..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    let searchBar = UISearchBar()
    let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: nil)
    let tableView = UITableView()
    
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MainViewModel) {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.active = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.active = false
    }
    
    
    func initUI() {
        let views = [
            "searchBar" : searchBar,
            "tableView" : tableView
        ]
        
        for (_, subview) in views {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        self.view.addConstraint(NSLayoutConstraint(item: searchBar, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[searchBar][tableView]|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchBar]|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: nil, views: views))
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func bindViewModel() {
        _ = searchBar.rx_text.bindTo(viewModel.searchTextObservable)
        
        _ = viewModel.contentChangesObservable.bindTo(tableView.rx_itemsWithCellFactory) {
                (tv: UITableView, index, item: Item) in
            
                let indexPath = NSIndexPath(forItem: index, inSection: 0)
                let cell = tv.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)
                cell.textLabel!.text = item.content
                cell.backgroundColor = item.done as! Bool ? UIColor.lightGrayColor() : UIColor.whiteColor()
                return cell as UITableViewCell
            }
            .addDisposableTo(disposeBag)
        
        _ = viewModel.titleObservable
            .subscribeNext { [unowned self] title in
                self.title = title
            }
            .addDisposableTo(disposeBag)
        
        _ = addBarButtonItem.rx_tap.subscribeNext { [unowned self] _ in
            let addViewController = AddViewController(viewModel: self.viewModel.addViewModel())
            let navigationController = UINavigationController(rootViewController: addViewController)
            self.presentViewController(navigationController, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }


}