//
//  ContactProvider.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 19/09/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Contacts

struct ContactProvider {
    private init() {}
    static var indexPress: Int?
    static var contactName: String?
    
    static func contactFormatter(contact: CNContact)->String {
        var fullName = ""
        var flag = true
        
        if (contact.givenName == "") && (contact.middleName == "") {
            fullName = contact.familyName
            flag = false
        } else if (contact.middleName == "") && (contact.familyName == "") && flag {
            fullName = contact.givenName
            flag = false
        } else if (contact.givenName == "") && (contact.familyName == "") && flag {
            fullName = contact.middleName
            flag = false
        } else if contact.givenName == "" && flag {
            fullName = contact.middleName + " " + contact.familyName
            flag = false
        } else if contact.middleName == "" && flag {
            fullName = contact.givenName + " " + contact.familyName
            flag = false
        } else if contact.familyName == "" && flag {
            fullName = contact.givenName + " " + contact.middleName
            flag = false
        } else {
            fullName = contact.givenName + " " + contact.middleName + " " + contact.familyName
        }
        
        if contact.namePrefix != "" {
            fullName = contact.namePrefix + " " + fullName
        }
        
        if contact.nameSuffix != "" {
            fullName = fullName + " " + contact.nameSuffix
        }
        return fullName
    }
    
}
