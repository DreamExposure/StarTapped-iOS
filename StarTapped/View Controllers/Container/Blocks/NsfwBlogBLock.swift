//
//  NsfwBlogBLock.swift
//  StarTapped
//
//  Created by Nova Maday on 1/16/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class NsfwBlogBlock: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var contentAlert: UILabel!
    @IBOutlet weak var contentDescription: UILabel!
    @IBOutlet weak var goBack: UIButton!
    
    var previousView: ViewType!
    var controller: UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("NsfwBlogBlock", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func fixTheStupid() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.layoutIfNeeded()
        
        self.heightAnchor
            .constraint(equalToConstant: self.contentView.frame.height)
            .isActive = true
        self.widthAnchor
            .constraint(equalToConstant: self.contentView.frame.width)
            .isActive = true
        
        self.layoutIfNeeded()
    }
    
    @IBAction func goBackAction() {
        self.controller.dismiss(animated: true, completion: nil)
    }
}
