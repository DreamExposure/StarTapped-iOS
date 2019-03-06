//
//  SettingsController.swift
//  StarTapped
//
//  Created by Nova Maday on 2/10/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import SwiftyJSON

class SettingsController: UIViewController {
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAccountSettingsClick() {
        ViewUtils().goToAccountSettings(view: self, anim: true)
    }
}
