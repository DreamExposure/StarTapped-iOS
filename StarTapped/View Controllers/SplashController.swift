//
//  SplashController.swift
//  StarTapped
//
//  Created by Nova Maday on 1/7/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class SplashController: UIViewController, TaskCallback {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkAuthorization()
    }

    func checkAuthorization() {
        let auth = Settings().getAuthentication()

        if auth.getRefreshToken() == "Unassigned" || auth.getAccessToken() == "Unassigned" {
            ViewUtils().goToAuth(view: self, anim: false)
        } else if (auth.getExpire() <= TimeUtils().getCurrentMillis()) {
            //attempt reauth and go to hub or auth
            
            let trt = TokenRefreshTask(callback: self)
            
            trt.execute()
        } else {
            ViewUtils().goToHub(view: self, anim: false)
        }
    }

    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .AUTH_TOKEN_REAUTH:
            if (status.isSuccess()) {
                if (status.getCode() == 201) {
                    //Save new credentials
                    Settings().deleteAuthentication()
                    let cred = JSON(status.getBody()["credentials"])
                    let auth = AccountAuthentication().fromJson(json: cred)
                    Settings().saveAuthentication(auth: auth)
                }
                ViewUtils().goToHub(view: self, anim: false)
            } else {
                ViewUtils().goToAuth(view: self, anim: false)
            }
            break
        default:
            //Unsupported action, ignore
            break
        }
    }
}
