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
    func goTo(view: UIViewController, anim: Bool, viewType: ViewType) {
        switch viewType {
        case .AUTH:
            goToAuth(view: view, anim: anim)
            break
        case .HUB:
            goToHub(view: view, anim: anim)
            break
        case .YOUR_BLOGS:
            goToYourBlogs(view: view, anim: anim)
            break
        default:
            break
        }
    }
    
    func goToAuth(view: UIViewController, anim: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "auth-controller") as! AuthController
        view.present(newViewController, animated: anim, completion: nil)
    }
    
    func goToHub(view: UIViewController, anim: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Hub", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "hub-controller") as! HubController
        view.present(newViewController, animated: anim, completion: nil)
    }
    
    func goToYourBlogs(view: UIViewController, anim: Bool) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Hub", bundle: nil)
        let newViewController = storyboard
            .instantiateViewController(withIdentifier: "your-blogs") as! YourBlogsController
        view.present(newViewController, animated: anim, completion: nil)
    }
    
    func goToViewBlog(view: UIViewController, anim: Bool, previous: ViewType, blogId: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Hub", bundle: nil)
        let newViewController = storyboard
            .instantiateViewController(withIdentifier: "blog-view") as! BlogViewController
        
        newViewController.previousView = previous
        newViewController.blogId = blogId
        
        view.present(newViewController, animated: anim, completion: nil)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
