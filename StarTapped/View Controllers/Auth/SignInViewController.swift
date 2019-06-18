//
//  SignInViewController.swift
//  StarTapped
//
//  Created by Nova Maday on 1/8/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import ReCaptcha
import SwiftyJSON

class SignInViewController: UIViewController, UITextFieldDelegate, TaskCallback {
    
    let recaptcha = try? ReCaptcha()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var recapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReCaptcha()
        email.delegate = self
        password.delegate = self
    }
    
    @IBAction
    func onSignInButtonClick() {
        //Handle sign in call
        let emailString = email.text ?? ""
        let passString = password.text ?? ""
        
        if (emailString.count > 0 && passString.count > 0) {
            self.validate(emailString: emailString, passString: passString)
        } else {
            self.view.makeToast("Email and Password are required")
        }
    }
    
    func onCallBack(status: NetworkCallStatus) {
        switch (status.getType()) {
        case .AUTH_LOGIN:
            if (status.isSuccess()) {
                Settings().deleteAuthentication()
                let cred = JSON(status.getBody()["credentials"])
                let auth = AccountAuthentication().fromJson(json: cred)
                Settings().saveAuthentication(auth: auth)
                
                ViewUtils().goToHub(view: self, anim: true)
            } else {
                self.view.makeToast(status.getMessage())
            }
        default:
            //Unsupported action
            break
        }
    }
    
    private func setupReCaptcha() {
        recaptcha?.configureWebView { [weak self] webview in
            webview.frame = self?.recapView.bounds ?? CGRect.zero
        }
        recapView.isHidden = true
    }
    
    func validate(emailString: String, passString: String) {
        recapView.isHidden = false
        recaptcha?.validate(on: recapView) { [weak self] (result: ReCaptchaResult) in
            
            let code = try! result.dematerialize()
            self?.recapView.isHidden = true
            
            //logic
            let lt = LoginTask(callback: self!, email: emailString, password: passString, gcap: code)
            
            lt.execute()
        }
    }
    
    func textFieldShouldReturn(_ text: UITextField) -> Bool {
        if text == email {
            text.resignFirstResponder()
            password.becomeFirstResponder()
        } else if text == password {
            //stop editing and sign in
            text.endEditing(true)
            self.onSignInButtonClick()
        }
        return true
    }
}
