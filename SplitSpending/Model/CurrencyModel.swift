//
//  LocID.swift
//  Debts
//
//  Created by Sergey Volkov on 01.10.2020.
//  Copyright © 2020 Sergey Volkov. All rights reserved.
//

import Foundation

struct CurrencyModel: Equatable, Hashable {
    static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        return (lhs.currencyCode == rhs.currencyCode)
    }
    var currencyCode: String
    var currencySymbol: String
    var localazedString: String
}
