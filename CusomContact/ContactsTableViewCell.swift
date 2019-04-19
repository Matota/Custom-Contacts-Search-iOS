//
//  ContactsTableViewCell.swift
//  CusomContact
//
//  Created by Hitesh on 22/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setOpaqueBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.contactImage.image = #imageLiteral(resourceName: "SelectedContact")
        }
    }
}

private extension ContactsTableViewCell {
    
    func setOpaqueBackground() {
        alpha = 1.0
    }
}
