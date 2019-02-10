//
//  AccountSettingsController.swift
//  StarTapped
//
//  Created by Nova Maday on 2/10/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import SwiftyJSON

class AccountSettingsController: UIViewController, TaskCallback {
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var safeSearchSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeSearchSwitch.setOn(Settings().getAccount().isSafeSearch(), animated: false)
    }
    
    @IBAction func onSafeSearchCheck() {
        let safeSearch: Bool = safeSearchSwitch.isOn
        
        let acc = Settings().getAccount()
        acc.setSafeSearch(safe: safeSearch)
        
        Settings().saveAccount(account: acc)
        
        //Handle update task
        let task = UpdateAccountTask(callback: self)
        task.execute()
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onCallBack(status: NetworkCallStatus) {
        switch (status.getType()) {
        case .ACCOUNT_UPDATE:
            if (status.isSuccess()) {
                self.view.makeToast("Success!")
            } else {
                self.view.makeToast(status.getMessage())
            }
            default:
                //Invalid
                break;
        }
    }
}
