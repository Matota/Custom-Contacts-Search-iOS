//  ContactsViewController.swift
//  CusomContact
//  Created by Hitesh on 21/03/18.
//  Copyright © 2018 Apple. All rights reserved.

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var cScrollView: UIScrollView!
    @IBOutlet weak var tableHeaderView: HeaderView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet weak var contactsTableView: UITableView!

    let contactTableDataSourceDelegate = ContactTableDataSourceDelegate()
    var selectedContacts: [Contacts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactTableDataSourceDelegate.contactDelegate = self
        self.setupSearchBarUI()
        self.setupTableView()
        self.setupHeaderUI()
    }

    private func setupSearchBarUI() {
        
        self.cScrollView.isHidden = true
        searchBar.getSearchField().leftView = UIImageView(image: #imageLiteral(resourceName: "search"))
        self.searchBar.delegate = self
        cScrollView.setInitialContactorigin()
        self.view.bringSubview(toFront: searchBar)
        searchBar.layer.shadowOpacity = 1.0
        searchBar.layer.shadowColor = UIColor.lightGray.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    private func setupTableView() {

        contactTableDataSourceDelegate.setupDataSource { (granted) in
            
            self.contactsTableView.dataSource = self.contactTableDataSourceDelegate
            self.contactsTableView.delegate = self.contactTableDataSourceDelegate
        }
    }
    
    private func setupHeaderUI() {
        
        self.tableHeaderView.setLabelUI(title: "  Phone Contacts")
    }
    
    @IBAction private func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.contactsTableView.separatorColor = .lightGray
            contactTableDataSourceDelegate.isSearchEnabled = false
            contactTableDataSourceDelegate.tableType = .contactList
        } else {
            self.searchBar.placeholder = ""
            self.contactsTableView.separatorColor = .clear
            contactTableDataSourceDelegate.isSearchEnabled = true
            contactTableDataSourceDelegate.tableType = .searchList
            contactTableDataSourceDelegate.filterContentForSearchText(searchText)
        }
        self.contactsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        contactTableDataSourceDelegate.isSearchEnabled = false
        self.contactsTableView.reloadData()
    }
}

extension ContactsViewController: ContactProtocol {

    func didSelectContact(contact: Contacts, indexPath: IndexPath) {
        
        let contacts = cScrollView.getContactViewObjects().filter{ $0.contact.fullName == contact.fullName }
        if contacts.count == 1 {
            contacts.first?.removeFromSuperview()
            cScrollView.repositionContactViews(except: contacts.first!)
        } else {
            self.searchBar.placeholder = ""
            let contactView = ContactView.loadFromNib()
            contactView.contactDelegate = self
            contactView.indexPath = indexPath
            let size = contactView.setContact(contact: contact)
            //searchBar.getSearchField().layoutIfNeeded()
            contactView.frame = CGRect(x: cScrollView.contactViewOrigin(), y: (cScrollView.frame.size.height - contactView.frame.size.height) / 2, width: size.width + 35, height: contactView.frame.size.height)
            cScrollView.nextContactViewOrigin(xPos: contactView.frame.size.width)
            self.cScrollView.addSubview(contactView)
            self.view.bringSubview(toFront: cScrollView)
            self.cScrollView.isHidden = false
        }
        let width = cScrollView.getContactViewObjects().reduce(35.0, { x, y in
            x + y.frame.size.width + 5
        })
        cScrollView.contentSize = CGSize(width: width, height: cScrollView.contentSize.height)
        
    }
    
    func didRemoveContact(contact: ContactView) {
        
        //cScrollView.repositionContactViews(except: contact)
        contactTableDataSourceDelegate.deselctCell(indexPath: contact.indexPath!, tableView: self.contactsTableView)
    }
}
