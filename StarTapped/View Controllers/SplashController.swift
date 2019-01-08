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
        // Do any additional setup after loading the view, typically from a nib.

        checkAuthorization()
    }

    func checkAuthorization() {
        let auth = Settings().getAuthentication()

        if auth.getRefreshToken() == "Unassigned" || auth.getAccessToken() == "Unassigned" {
            goToAuth()
        } else if (auth.getExpire() <= TimeUtils().getCurrentMillis()) {
            //TODO: attempt reauth and go to hub or auth

        } else {
            //Something unknown was reached, default to making the user login...
            goToAuth()
        }
    }

    func goToAuth() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "auth-controller") as! AuthController
        self.present(newViewController, animated: false, completion: nil)
    }
    
    func goToHub() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Hub", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "hub-controller") as! AuthController
        self.present(newViewController, animated: false, completion: nil)
    }

    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .AUTH_TOKEN_REAUTH:
            if (status.isSuccess()) {
                if (status.getCode() == 200) {
                    //Save new credentials
                    Settings().deleteAuthentication()
                    let cred = JSON(status.getBody()["credentials"].stringValue)
                    let auth = AccountAuthentication().fromJson(json: cred)
                    Settings().saveAuthentication(auth: auth)
                }
                //TODO: Go to hub
            } else {
                goToAuth()
            }
            break
        default:
            //Unsupported action, ignore
            break
        }
    }
}
