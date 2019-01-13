//
//  BlogForSelfListContainer.swift
//  StarTapped
//
//  Created by Nova Maday on 1/12/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit

class BlogForSelfListConainer: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var edtButton: UIButton!
    @IBOutlet weak var urlView: UILabel!
    
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogDescription: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("BlogForSelfList", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func fixTheStupid() {
        blogTitle.sizeToFit()
        blogTitle.setNeedsDisplay()
        blogDescription.sizeToFit()
        blogDescription.setNeedsDisplay()
        
        self.heightAnchor
            .constraint(equalToConstant: self.contentView.bounds.height)
            .isActive = true
        self.widthAnchor
            .constraint(equalToConstant: self.contentView.bounds.width)
            .isActive = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

