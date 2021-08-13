//
//  CalculateCell.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 27/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

class CalculateCell: UITableViewCell {
    
    @IBOutlet weak var debtorNameLabel: UILabel!
    @IBOutlet weak var creditorNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var backgroundViewCell: UIView!
    
    func configureCell(indexPath: IndexPath, resultPair: [ResultPairModel]){
        debtorNameLabel.text = resultPair[indexPath.row].debtor
        creditorNameLabel.text = resultPair[indexPath.row].creditor
        let dec = Decimal(Double(resultPair[indexPath.row].payment))
        amountLabel.text = Currency.currencyFormatter(currency: dec,
                                                      currencyCode: CurrencyViewModel.shared.selectedCurrency.currencyCode,
                                                      showCode: false)
        backgroundViewCell.layer.cornerRadius = 12
    }
}
