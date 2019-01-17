//
//  AdultOnlyBlock.swift
//  StarTapped
//
//  Created by Nova Maday on 1/16/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AdultOnlyBlock: UIView {
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
        Bundle.main.loadNibNamed("AdultOnlyBlock", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func fixTheStupid() {
        self.heightAnchor
            .constraint(equalToConstant: self.contentView.bounds.height)
            .isActive = true
        self.widthAnchor
            .constraint(equalToConstant: self.contentView.bounds.width)
            .isActive = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @IBAction func goBackAction() {
        self.controller.dismiss(animated: true, completion: nil)
    }
}
