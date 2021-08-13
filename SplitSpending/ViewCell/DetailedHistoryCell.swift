//
//  DetailedHistoryCell.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 16.12.2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

class DetailedHistoryCell: UITableViewCell {
    
    private let overviewTitle = [LocalizedString.date, LocalizedString.ShareMessage.totalExpenses, LocalizedString.ShareMessage.numberOfPersons, LocalizedString.ShareMessage.expensesPerPerson]
    
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    func configureCell(history: HistoryModel, indexPath: IndexPath) {
        
        
        let overviewText = [
            MyDateFormatter.formatter(dateStyle: .short, timeStyle: .short).string(from: history.date),
            Currency.currencyFormatter(currency: Decimal(Double(history.totalExpenses)),
                                       currencyCode: history.currency,
                                       showCode: CurrencyViewModel.shared.showCurrencyCode),
            history.numberOfPerson.description,
            Currency.currencyFormatter(currency: Decimal(Double(history.perPerson)),
                                       currencyCode: history.currency,
                                       showCode: CurrencyViewModel.shared.showCurrencyCode)
        ]
        switch indexPath.section {
        case 0:
            firstTextLabel.text = overviewTitle[indexPath.row]
            secondTextLabel.text = overviewText[indexPath.row]
            secondTextLabel.widthAnchor.constraint(equalToConstant: CGFloat(overviewText[indexPath.row].count) * 10).isActive = true
        case 1:
            let historyAmount = Currency.currencyFormatter(currency: Decimal(Double(history.totalCost[indexPath.row].amount ?? 0)),
                                                           currencyCode: history.currency,
                                                           showCode: CurrencyViewModel.shared.showCurrencyCode)
            firstTextLabel.text = history.totalCost[indexPath.row].name
            secondTextLabel.text = historyAmount
            secondTextLabel.widthAnchor.constraint(equalToConstant: CGFloat(historyAmount.count) * 10).isActive = true
        case 2:
            let historyPayments = Currency.currencyFormatter(currency: Decimal(Double(history.resultPair[indexPath.row].payment)),
                                                             currencyCode: history.currency,
                                                             showCode: CurrencyViewModel.shared.showCurrencyCode)
            firstTextLabel.text = history.resultPair[indexPath.row].debtor + " \u{2192} " + history.resultPair[indexPath.row].creditor
            secondTextLabel.text = historyPayments
            secondTextLabel.widthAnchor.constraint(equalToConstant: CGFloat(historyPayments.count) * 10).isActive = true
        default:
            break
        }
        firstTextLabel.sizeToFit()
        stackView.sizeToFit()
    }
}
