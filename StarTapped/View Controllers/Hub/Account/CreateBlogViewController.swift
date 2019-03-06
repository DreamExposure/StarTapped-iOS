//
//  CreateBlogViewController.swift
//  StarTapped
//
//  Created by Nova Maday on 1/18/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import SwiftyJSON
import ReCaptcha

class CreateBlogViewController: UIViewController, TaskCallback {
    
    let recaptcha = try? ReCaptcha()
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var blogUrl: UITextField!
    
    @IBOutlet weak var recapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         setupReCaptcha()
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCreateButtonClicked() {
        let urlString = self.blogUrl.text ?? ""
        
        if (Validator().validBlogUrlLength(input: urlString)) {
            self.validate(urlString: urlString)
        } else {
            self.view.makeToast("URL must be between 3 and 60 characters long.")
        }
    }
    
    private func setupReCaptcha() {
        recaptcha?.configureWebView { [weak self] webview in
            webview.frame = self?.recapView.bounds ?? CGRect.zero
        }
        recapView.isHidden = true
    }
    
    func validate(urlString: String) {
        recapView.isHidden = false
        recaptcha?.validate(on: recapView) { [weak self] (result: ReCaptchaResult) in
            
            let code = try! result.dematerialize()
            self?.recapView.isHidden = true
            
            //logic
            let cbt = CreateBlogTask(callback: self!, url: urlString, gcap: code)
            cbt.execute()
        }
    }
    
    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .BLOG_CREATE:
            if (status.isSuccess()) {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.view.makeToast(status.getMessage())
            }
            break
        default:
            //Unsupported action
            break
        }
    }
}
