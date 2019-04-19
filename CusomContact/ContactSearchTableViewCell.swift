//  ContactSearchTableViewCell.swift
//  CusomContact
//
//  Created by Hitesh on 23/03/18.
//  Copyright © 2018 Apple. All rights reserved.

import UIKit

class ContactSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var initials: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.setOpaqueBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        guard selected else { return }
        if let _ = selectionImage.image?.imageAsset {

            UIView.transition(with: self.selectionImage, duration: 1.0, options: .transitionFlipFromRight, animations: {
                self.selectionImage.image = UIImage()
            }, completion: nil)
        } else {
            UIView.transition(with: self.selectionImage, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.selectionImage.image = #imageLiteral(resourceName: "Selected Recent")
            }, completion: nil)
        }
    }
    
    func setupCircularinitials() {
        
        initials.isOpaque                  = false
        initials.textAlignment             = .center
        initials.lineBreakMode             = .byWordWrapping
        initials.minimumScaleFactor        = 0.6
        initials.adjustsFontSizeToFitWidth = true
        initials.numberOfLines             = 1
        initials.textColor                 = .white
        initials.font                      = UIFont.systemFont(ofSize: 18.0)
        initials.layer.cornerRadius        = CGFloat(25.0)
        initials.layer.masksToBounds       = true
    }
}
    
private extension ContactSearchTableViewCell {
    
    func setOpaqueBackground() {
        alpha = 1.0
        selectionImage.image = UIImage()
    }
}
