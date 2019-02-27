//
// Created by Nova Maday on 2019-02-26.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import FRHyperLabel
import UITextView_Placeholder
import PopupDialog
import SwiftyJSON

class BlogEditContainer: UIView, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!

    @IBOutlet weak var displayAgeLabel: UILabel!
    
    @IBOutlet weak var nsfwBadge: UILabel!
    @IBOutlet weak var noMinorsBadge: UILabel!
    @IBOutlet weak var ageBadge: UILabel!

    //Editable/user interaction stuffs
    @IBOutlet weak var blogName: UITextView!
    @IBOutlet weak var blogDescription: UITextView!

    @IBOutlet weak var isNsfwSwitch: UISwitch!
    @IBOutlet weak var allowMinorsSwitch: UISwitch!
    @IBOutlet weak var displayAgeSwitch: UISwitch!



    //Constraints
    var contentHeight: NSLayoutConstraint!
    var blogNameHeight: NSLayoutConstraint!
    var blogDescriptionHeight: NSLayoutConstraint!

    //Other stuffs
    var controller: UIViewController!
    var toolbarTitle: UIBarButtonItem!

    var currentPicker: String = "None"

    //Blog stuffs
    var backgroundImageFile: [String: String]?
    var iconImageFile: [String: String]?

    var blog: Blog!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        Bundle.main.loadNibNamed("BlogEditContainer", owner: self  , options: nil)
        self.addSubview(self.contentView)

        self.contentHeight = self.heightAnchor.constraint(equalToConstant: 800)
        self.contentHeight.isActive = true

        self.blogName.delegate = self
        self.blogDescription.delegate = self
        self.blogNameHeight = self.blogName.heightAnchor.constraint(equalToConstant: self.blogName.frame.height)
        self.blogDescriptionHeight = self.blogDescription.heightAnchor.constraint(equalToConstant: self.blogDescription.frame.height)
        self.blogNameHeight.isActive = true
        self.blogDescriptionHeight.isActive = true
    }

    func configureWithBlog(blog: Blog) {
        self.blog = blog

        self.toolbarTitle.title = self.blog.getBaseUrl()

        //Set images
        let bgImage: UploadedFile = self.blog.getBackgroundImage()
        let icImage: UploadedFile = self.blog.getIconImage()
        self.backgroundImage.sd_setImage(with: URL(string: bgImage.getUrl()))
        self.iconImage.sd_setImage(with: URL(string: icImage.getUrl()))

        //Set main text..
        self.blogName.text = self.blog.getName()
        self.textViewDidChange(self.blogName)
        self.blogDescription.text = self.blog.getDescription()
        self.textViewDidChange(self.blogDescription)

        //Set switches and badges
        self.nsfwBadge.isHidden = !self.blog.isNsfw()
        self.isNsfwSwitch.setOn(self.blog.isNsfw(), animated: false)

        self.noMinorsBadge.isHidden = self.blog.doesAllowUnder18()
        self.allowMinorsSwitch.setOn(self.blog.doesAllowUnder18(), animated: false)

        if blog.getBlogType() == .PERSONAL {
            self.displayAgeSwitch.setOn(self.blog.isDisplayAge(), animated: false)
            self.ageBadge.text = "\(TimeUtils().calculateAge(ageString: Settings().getAccount().getBirthday()))"
            if blog.isDisplayAge() {
                self.ageBadge.isHidden = false
            } else {
                self.ageBadge.isHidden = true
            }
        } else {
            self.ageBadge.isHidden = true
            self.displayAgeLabel.isHidden = true
        }
    }

    @IBAction func onIsNsfwChange() {
        self.nsfwBadge.isHidden = !self.isNsfwSwitch.isOn
    }

    @IBAction func onAllowMinorsChange() {
        self.noMinorsBadge.isHidden = self.allowMinorsSwitch.isOn
    }

    @IBAction func onDisplayAgeChange() {
        self.ageBadge.isHidden = !self.displayAgeSwitch.isOn
    }

    @IBAction func onChangeBlogBackgroundImageClick() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.openImagePicker(sourceType: .camera, forPart: "Background")
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.openImagePicker(sourceType: .photoLibrary, forPart: "Background")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.controller.present(alert, animated: true, completion: nil)
    }

    @IBAction func onChangeBlogIconImageClick() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.openImagePicker(sourceType: .camera, forPart: "Icon")
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.openImagePicker(sourceType: .photoLibrary, forPart: "Icon")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.controller.present(alert, animated: true, completion: nil)
    }

    func openImagePicker(sourceType: UIImagePickerController.SourceType, forPart: String) {
        if sourceType == .camera {
            self.currentPicker = "Camera-\(forPart)"
        } else if sourceType == .photoLibrary {
            self.currentPicker = "Gallery-\(forPart)"
        }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = false
        self.controller.present(picker, animated: true, completion: nil)
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

    func textViewDidChange(_ textView: UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = false

        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(MAXFLOAT)))

        textView.frame.size.height = newSize.height
        textView.setNeedsDisplay()
        textView.setNeedsUpdateConstraints()

        if textView == blogName {
            blogNameHeight.constant = newSize.height
        } else {
            blogDescriptionHeight.constant = newSize.height
        }

        textView.isScrollEnabled = false

        self.fixTheStupid()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if self.currentPicker == "Camera-Background" {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

            self.backgroundImage.image = image
            self.backgroundImageFile = FileUtils().imageToBase64(image: image!)
        } else if self.currentPicker == "Gallery-Background" {
            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL

            self.backgroundImage.sd_setImage(with: imageUrl!)
            self.backgroundImageFile = FileUtils().fileToBase64(filePath: (imageUrl?.path)!)
        } else if self.currentPicker == "Camera-Icon" {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

            self.iconImage.image = image
            self.iconImageFile = FileUtils().imageToBase64(image: image!)
        } else if self.currentPicker == "Gallery-Icon" {
            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL

            self.iconImage.sd_setImage(with: imageUrl!)
            self.iconImageFile = FileUtils().fileToBase64(filePath: (imageUrl?.path)!)
        }
        picker.dismiss(animated: true, completion: nil)
        self.currentPicker = "None"
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.currentPicker = "None"
    }
}
