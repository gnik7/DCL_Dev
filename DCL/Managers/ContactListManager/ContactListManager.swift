//
//  ContactListManager.swift
//  DCL
//
//  Created by Nikita on 4/11/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import Contacts

class ContactListManager {
    
    static let sharedInstance = ContactListManager()
    
    let contactStore = CNContactStore()
    
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            
                            print(message)
                            guard let vc = UIApplication.shared.keyWindow?.rootViewController else {return}
                            Alert.show(controller: vc, title: AlertTitle.Error, message: message, action: nil)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func retrieveContactsWithStore(store: CNContactStore) -> [CNContact]? {
        do {
            var contacts: [CNContact] = []
            try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])) {
                (contact, cursor) -> Void in
                contacts.append(contact)
            }
            return contacts
        } catch {
            print(error)
        }
        return nil
    }
}

