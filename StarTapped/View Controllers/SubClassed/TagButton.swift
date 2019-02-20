//
//  TagButton.swift
//  StarTapped
//
//  Created by Nova Maday on 2/19/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

class TagButton: MDCButton {
    var postTag: String?
    
    //TODO: Test this!!!
    override var intrinsicContentSize: CGSize
        {
        get {
            let labelSize = titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40)) ?? CGSize.zero
            let reqiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
            
            return reqiredButtonSize
        }
    }
}
