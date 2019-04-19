//
//  HeaderView.swift
//  CusomContact
//
//  Created by Hitesh on 22/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet private weak var headerlabel: UILabel!
    
    func setLabelUI(title: String) {
        
        self.headerlabel.text = title
    }
}


