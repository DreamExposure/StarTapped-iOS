//
//  RegisterViewController.swift
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

class RegisterViewController: UIViewController, TaskCallback {
    
    let recaptcha = try? ReCaptcha()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    
    @IBOutlet weak var recapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReCaptcha()
    }
    
    @IBAction
    func onRegisterButtonClick(button: UIButton) {
        let usernameText = username.text ?? ""
        let emailText = email.text ?? ""
        let birthdate = birthday.date
        let passwordText = password.text ?? ""
        let passwordRetypeText = retypePassword.text ?? ""
        
        if (usernameText.count > 0 && emailText.count > 0 && passwordText.count > 0 && passwordRetypeText.count > 0) {
            if (!TimeUtils().dateIsInFuture(date1: birthdate)) {
                if (passwordText == passwordRetypeText) {
                    let birthString = TimeUtils().dateToDatabaseFormat(date: birthdate)
                    
                    self.validate(usernameString: usernameText, emailString: emailText, birthString: birthString, passString: passwordText)
                } else {
                    self.view.makeToast("Passwords do not match!")
                }
            } else {
                self.view.makeToast("Invalid Birthday, you can't be born in the future!")
            }
        } else {
            self.view.makeToast("All fields are required!")
        }
    }
    
    func onCallBack(status: NetworkCallStatus) {
        switch (status.getType()) {
        case .AUTH_REGISTER:
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
    
    func validate(usernameString: String, emailString: String, birthString: String, passString: String) {
        recapView.isHidden = false
        recaptcha?.validate(on: recapView) { [weak self] (result: ReCaptchaResult) in
            
            let code = try! result.dematerialize()
            
            self?.recapView.isHidden = true
            
            //logic
            let rt = RegisterTask(callback: self!, user: usernameString, email: emailString, birthday: birthString, password: passString, gcap: code)
            
            rt.execute()
        }
    }
}
