//
//  ResultPairModel.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 12.12.2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation

struct ResultPairModel: Codable {
    var debtor: String
    var creditor: String
    var payment: Float
    
    var dictionary : NSDictionary {
        let dictionary = NSDictionary(objects: [debtor, creditor, payment], forKeys: ["debtor" as NSCopying, "creditor" as NSCopying, "payment" as NSCopying])
        return dictionary
    }
    
    init(debtor: String, creditor: String, payment: Float) {
        self.debtor = debtor
        self.creditor = creditor
        self.payment = payment
    }
    
    init(dictionary: NSDictionary) {
        var debtor: String
        var creditor: String
        var payment: Float
        
        if let debtorInit = dictionary.object(forKey: "debtor") as? String {debtor = debtorInit} else {debtor = ""}
        if let creditorInit = dictionary.object(forKey: "creditor") as? String {creditor = creditorInit} else {creditor = ""}
        if let paymentInit = dictionary.object(forKey: "payment") as? Float {payment = paymentInit} else {payment = 0}
       
        self.init(debtor: debtor, creditor: creditor, payment: payment)
    }
}
