//
//  ViewController.swift
//  RxLogin
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 21..
//  Copyright © 2016년 burt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let validUsernameObservable = usernameTextField
            .rx_text
            .map { username in
                username.characters.count > 5
            }
            .distinctUntilChanged()
        
        let validPasswordObservable = passwordTextField
            .rx_text
            .map { password in
                password.characters.count > 5
            }
            .distinctUntilChanged()
        
        _ = validUsernameObservable
            .map { value in
                value ? UIColor.greenColor() : UIColor.whiteColor()
            }
            .subscribeNext { [unowned self] value in
                self.usernameTextField.backgroundColor = value
            }
            .addDisposableTo(disposeBag)
        
        _ = validPasswordObservable
            .subscribeNext { value in
                print("Password : " + String(value))
            }
            .addDisposableTo(disposeBag)
        
        
        Observable.combineLatest(validUsernameObservable, validPasswordObservable) { usernameValid, passwordValid in
                return usernameValid && passwordValid
        }
        .bindTo(loginButton.rx_enabled)
        .addDisposableTo(disposeBag)
        
        
        
        loginButton
            .rx_tap
            .flatMap { [unowned self] in
                self.parseLogin()
            }
            .subscribeNext { value in
                let alert = UIAlertController(title: value, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }

    func parseLogin() -> Observable<String> {
        return Observable.create { [unowned self] observer in
            PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!) { user, error in
                observer.onNext(user?.username ?? "Try again")
                observer.onCompleted()
            }
            return NopDisposable.instance
        }
    }
}

