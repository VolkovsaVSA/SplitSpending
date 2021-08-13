//
//  HistoryModel.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 12.12.2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation

struct HistoryModel: Codable {
    var totalExpenses: Float
    var numberOfPerson: Int
    var perPerson: Float
    var resultPair: [ResultPairModel]
    let date: Date
    var totalCost: [Debt]
    var currency: String
    
    var dictionary : NSDictionary {
        
        var arrayResultPair = NSArray()
        for itemResultPair in resultPair {
            arrayResultPair = arrayResultPair.adding(itemResultPair.dictionary) as NSArray
        }
        var arrayTotalCost = NSArray()
        for itemTotalCost in totalCost {
            arrayTotalCost = arrayTotalCost.adding(itemTotalCost.dictionary) as NSArray
        }
        
        let dictionary = NSDictionary(objects: [totalExpenses, numberOfPerson, perPerson, arrayResultPair, date, arrayTotalCost, currency], forKeys: ["totalExpenses" as NSCopying, "numberOfPerson" as NSCopying, "perPerson" as NSCopying, "resultPair" as NSCopying, "date" as NSCopying, "totalCost" as NSCopying, "currency" as NSCopying])
        return dictionary
    }
    
    init(totalExpenses: Float, numberOfPerson: Int, perPerson: Float, resultPair: [ResultPairModel], date: Date, totalCost: [Debt], currency: String) {
        self.totalExpenses = totalExpenses
        self.numberOfPerson = numberOfPerson
        self.perPerson = perPerson
        self.resultPair = resultPair
        self.date = date
        self.totalCost = totalCost
        self.currency = currency
    }
    
    init(dictionary: NSDictionary) {
        var totalExpenses: Float
        var numberOfPerson: Int
        var perPerson: Float
        var resultPair: [ResultPairModel]
        let date: Date
        var totalCost: [Debt]
        var currency: String
        
        if let totalExpensesInit = dictionary.object(forKey: "totalExpenses") as? Float {totalExpenses = totalExpensesInit} else {totalExpenses = 0}
        if let numberOfPersonInit = dictionary.object(forKey: "numberOfPerson") as? Int {numberOfPerson = numberOfPersonInit} else {numberOfPerson = 0}
        if let perPersonInit = dictionary.object(forKey: "perPerson") as? Float {perPerson = perPersonInit} else {perPerson = 0}
        if let resultPairInit = dictionary.object(forKey: "resultPair") as? NSArray {
            
            var resultPairArray = [ResultPairModel]()
            for itemResultPairInit in resultPairInit {
                let tempData = ResultPairModel(dictionary: itemResultPairInit as! NSDictionary)
                resultPairArray.append(tempData)
            }
            resultPair = resultPairArray
        } else {
            resultPair = []
        }
        if let dateInit = dictionary.object(forKey: "date") as? Date {date = dateInit} else {date = Date()}
        if let totalCostInit = dictionary.object(forKey: "totalCost") as? NSArray {
            
            var totalCostArray = [Debt]()
            for itemTotalCostInit in totalCostInit {
                let tempData = Debt(dictionary: itemTotalCostInit as! NSDictionary)
                totalCostArray.append(tempData)
            }
            
            totalCost = totalCostArray
        } else {
            totalCost = []
        }
        
        if let currencyInit = dictionary.object(forKey: "currency") as? String {currency = currencyInit} else {currency = Currency.CurrentLocal.currencyCode}
        
        self.init(totalExpenses: totalExpenses, numberOfPerson: numberOfPerson, perPerson: perPerson, resultPair: resultPair, date: date, totalCost: totalCost, currency: currency)
    }
}
