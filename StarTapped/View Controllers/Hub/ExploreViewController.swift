//
//  ExploreViewController.swift
//  StarTapped
//
//  Created by Nova Maday on 1/17/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import Popover
import SwiftyJSON

class ExploreViewController: UIViewController, TaskCallback {
    
    @IBOutlet weak var moreButton: UIBarButtonItem!
    
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.auto),
        .blackOverlayColor(UIColor(red:0.12, green:0.15, blue:0.21, alpha:0.6))
    ]
    fileprivate var texts = ["Your Blogs", "Following", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let startPoint = CGPoint(x: self.view.frame.width - 60, y: 55)
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: CGFloat(42 * texts.count)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.popover = Popover(options: self.popoverOptions)
        self.popover.show(tableView, point: startPoint)
    }
    
    func onCallBack(status: NetworkCallStatus) {
        //TODO: Handle explore data callback.
    }
}

extension ExploreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            ViewUtils().goToYourBlogs(view: self, anim: true)
            break
        case 1:
            ViewUtils().goToFollowing(view: self, anim: true)
            break
        case 2:
            //TODO: Go to settings
            break
        default:
            //Unsupported action
            break
        }
        self.popover.dismiss()
    }
}

extension ExploreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
        return cell
    }
}

