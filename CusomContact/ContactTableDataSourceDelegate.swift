//  ContactTableDataSourceDelegate.swift
//  CusomContact
//
//  Created by Hitesh on 22/03/18.
//  Copyright © 2018 Apple. All rights reserved.

import UIKit
import Contacts

struct Contacts {
    
    var name: String?
    let phoneNum: String
    let phoneType: String
    var familyName: String?
    let fullName: String
    
    func displayAbbreviation() -> String {
        
        var firstLetters = ""
        if let fName = name, fName.count > 0 {
            
            firstLetters += String(describing: fName.first!)
        }
        if let lName = familyName, lName.count > 0 {
            
            firstLetters += String(describing: lName.first!)
        }
        return firstLetters
    }
}

enum TableViewType {
    
    case contactList
    case searchList
}

protocol ContactProtocol: class {
    
    func didSelectContact(contact: Contacts, indexPath: IndexPath)
    func didRemoveContact(contact: ContactView)
}

class ContactTableDataSourceDelegate: NSObject, UITableViewDataSource {

    private var allContacts: [Contacts]!
    private var filteredContacts: [Contacts]!
    private var contactList: [String : [Contacts]]!
    private var headerTitle: [String]!
    var isSearchEnabled: Bool = false
    var tableType: TableViewType = .contactList
    var contactDelegate: ContactProtocol?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if case .contactList = tableType {
            
            return headerTitle.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if case .contactList = tableType {
            return (contactList[headerTitle[section]]?.count)!
        } else {
            return filteredContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if case .contactList = tableType {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactsTableViewCell.self)) as? ContactsTableViewCell else {
                return UITableViewCell()
            }
            let contacts = contactList[headerTitle[indexPath.section]]
            print(contacts![indexPath.row].displayAbbreviation())
            cell.nameLabel.text = contacts![indexPath.row].fullName
            cell.phoneLabel.text = "\(contacts![indexPath.row].phoneType): \(contacts![indexPath.row].phoneNum)"
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactSearchTableViewCell.self)) as? ContactSearchTableViewCell else {
                return UITableViewCell()
            }
            let contact = filteredContacts[indexPath.row]
            cell.initials.text = contact.displayAbbreviation()
            cell.userName.text = contact.fullName
            cell.setupCircularinitials()
            cell.initials.backgroundColor = ThemeColors.updateInitialsColorForIndexPath(indexPath)
            return cell
        }
    }
}

extension ContactTableDataSourceDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if case .contactList = tableType {
             return headerTitle
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if case .contactList = tableType {
            return headerTitle[section]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if case .contactList = tableType {
            contactDelegate?.didSelectContact(contact: contactList[headerTitle[indexPath.section]]![indexPath.row], indexPath: indexPath)
        } else {
             contactDelegate?.didSelectContact(contact: filteredContacts[indexPath.row], indexPath: indexPath)
        }
        //(tableView.cellForRow(at: indexPath))?.isSelected = true
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func deselctCell(indexPath: IndexPath, tableView: UITableView) {
        
        (tableView.cellForRow(at: indexPath))?.isSelected = true
        self.tableView(tableView, didSelectRowAt: indexPath)
    }
}

extension ContactTableDataSourceDelegate {
    
    func allowedContactKeys() -> [CNKeyDescriptor] {
        
        return [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactMiddleNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
    }

    func fetchContactDetails() -> [Contacts] {
        
        var results: [Contacts] = []
        let contactStore = CNContactStore()
        let contactFetchRequest = CNContactFetchRequest(keysToFetch: self.allowedContactKeys())
        contactFetchRequest.sortOrder = CNContactSortOrder.userDefault
        do {
            try contactStore.enumerateContacts(with: contactFetchRequest) { (contactObj, stop) in
            
                if contactObj.phoneNumbers.count > 0  {
                    let number = contactObj.phoneNumbers[0]
                    
                    let contact = Contacts(name: contactObj.givenName, phoneNum: number.value.stringValue, phoneType: CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: number.label ?? ""), familyName: contactObj.familyName, fullName: "\(contactObj.givenName) \(contactObj.familyName)")
                    results.append(contact)
                }
            }
        } catch let error as NSError {
            
            print(error.localizedDescription)
        }
        return results
    }
    
    func requestContactPermission(completion: (() -> ())?) {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
            
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts, completionHandler: {
                success, error in
                completion?()
            })
        case .restricted, .denied:
            completion?()
        case .authorized:
            completion?()
        }
    }
    
    func setupDataSource(grantedHandler: @escaping (Bool)->()) {
        
        requestContactPermission {
            
            self.allContacts = self.fetchContactDetails()
            let addressBook = Dictionary(grouping: self.allContacts) {
                $0[keyPath: \Contacts.fullName].prefix(1).uppercased()
            }
            self.headerTitle = addressBook.keys.sorted(by: <)
            self.contactList = addressBook
            grantedHandler(true)
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredContacts = allContacts.filter({( contact : Contacts) -> Bool in
            return contact.fullName.lowercased().contains(searchText.lowercased())
        })
    }
}
