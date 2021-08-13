//
//  Model.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 15/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation

struct Debt: Codable {
    var name: String
    var amount: Float?
    
    var dictionary : NSDictionary {
        let dictionary = NSDictionary(objects: [name, amount ?? 0], forKeys: ["name" as NSCopying, "amount" as NSCopying])
        return dictionary
    }
    
    init(name: String, amount: Float?) {
        self.name = name
        self.amount = amount
    }
    
    init(dictionary: NSDictionary) {
        var name: String
        var amount: Float
        
        if let nameInit = dictionary.object(forKey: "name") as? String {name = nameInit} else {name = ""}
        if let amountInit = dictionary.object(forKey: "amount") as? Float {amount = amountInit} else {amount = 0}
        
        self.init(name: name, amount: amount)
    }
}

struct PendingModel {
    var name: String
    var amount: Float
    var difference: Float
}

var ResultPair = [ResultPairModel]()
var HistoryArr = [HistoryModel]()

