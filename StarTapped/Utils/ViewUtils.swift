//
//  ViewUtils.swift
//  StarTapped
//
//  Created by Nova Maday on 1/8/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit

class ViewUtils {
    func goToHub(view: UIViewController, anim: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Hub", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "hub-controller") as! HubController
        view.present(newViewController, animated: anim, completion: nil)
    }
    
    func goToAuth(view: UIViewController, anim: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "auth-controller") as! AuthController
        view.present(newViewController, animated: anim, completion: nil)
    }
}
