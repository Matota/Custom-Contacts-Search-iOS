//  ContactView.swift
//  CusomContact
//
//  Created by Hitesh on 25/03/18.
//  Copyright © 2018 Apple. All rights reserved.

import UIKit

protocol ContactUIView {}
extension UIView : ContactUIView {}
extension ContactUIView where Self : UIView {
    static func loadFromNib() -> Self {
        let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}

class ContactView: UIView {

    @IBOutlet weak var userName: UILabel!
    var contact: Contacts!
    var contactDelegate: ContactProtocol?
    var indexPath: IndexPath?

    @IBAction func removeUserClicked(_ sender: Any) {

        contactDelegate?.didRemoveContact(contact: self)
    }
    
    func setContact(contact: Contacts) -> CGSize {
        
        self.contact = contact
        self.userName.text = contact.fullName
        self.setCornerRadius()
        let size = contact.fullName.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0)])
        return size
    }
    
    private func setCornerRadius() {
        
        self.layer.cornerRadius =  15.0
        self.layer.masksToBounds = true
    }
}

extension ContactView {

    static func ==(lhs: ContactView, rhs: ContactView) -> Bool {

        return lhs.userName == rhs.userName
    }
}

private var xoAssociationKey: UInt8 = 0
extension UISearchBar {
    
    func getSearchField() -> UITextField {
        
        return self.value(forKey: "searchField") as! UITextField
    }
}

extension UIScrollView {
    
    func contactViewOrigin() -> CGFloat {
        
        return nextOriginX
    }
    
    func nextContactViewOrigin(xPos: CGFloat)  {
        
        nextOriginX = nextOriginX + xPos + 5
    }
    
    func setInitialContactorigin() {
        
        nextOriginX = 35.0
    }
    
    private var nextOriginX: CGFloat! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? CGFloat
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func getContactViewObjects() -> [ContactView] {
        
        return self.subviews.compactMap{ $0 as? ContactView }
    }
    
    func repositionContactViews(except contact: ContactView) {
        
        setInitialContactorigin()
        let viewNos = self.getContactViewObjects().map { cv in
            if !(cv == contact) {
                cv.frame = CGRect(x: self.contactViewOrigin(), y: cv.frame.origin.y, width: cv.frame.size.width, height: cv.frame.size.height)
                self.nextContactViewOrigin(xPos: cv.frame.size.width)
            }
            }.count
        if viewNos == 0 {
            setInitialContactorigin()
            self.isHidden = true
        }
    }
}
