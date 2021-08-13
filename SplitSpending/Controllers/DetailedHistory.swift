//
//  DetailedHistory.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 13.12.2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

class DetailedHistory: UITableViewController {
    var history: HistoryModel!
    private let headerTitle = [LocalizedString.TVCSectionHeader.total, LocalizedString.TVCSectionHeader.expenses, LocalizedString.TVCSectionHeader.payments]
    private let overviewTitle = [LocalizedString.date, LocalizedString.ShareMessage.totalExpenses, LocalizedString.ShareMessage.numberOfPersons, LocalizedString.ShareMessage.expensesPerPerson]
    
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        
        var shareObject = [String]()
        let totalExpensesLocal = history.totalExpenses
        let numberOfPersonLocal = history.numberOfPerson
        let perPersonLocal = history.perPerson
        
        shareObject.append(LocalizedString.date + ": " + MyDateFormatter.formatter(dateStyle: .medium, timeStyle: .short).string(from: Date()))
        shareObject.append(LocalizedString.ShareMessage.totalExpenses + ": " +
                           Currency.currencyFormatter(currency: Decimal(Double(totalExpensesLocal)),
                                                      currencyCode: history.currency,
                                                      showCode: CurrencyViewModel.shared.showCurrencyCode)
        )
        shareObject.append(LocalizedString.ShareMessage.numberOfPersons + ": " + numberOfPersonLocal.description)
        shareObject.append(LocalizedString.ShareMessage.expensesPerPerson + ": " +
                           Currency.currencyFormatter(currency: Decimal(Double(perPersonLocal)),
                                                      currencyCode: history.currency,
                                                      showCode: CurrencyViewModel.shared.showCurrencyCode)
        )
        shareObject.append(" ")
        shareObject.append(LocalizedString.ShareMessage.payouts + ":")
        shareObject.append(" ")
        
        
        for object in history.resultPair {
            let payment = "\(object.debtor) \u{2192} \(object.creditor) \(Currency.currencyFormatter(currency: Decimal(Double(object.payment)), currencyCode: history.currency, showCode: CurrencyViewModel.shared.showCurrencyCode))."
            shareObject.append(payment)
            shareObject.append(" ")
            
        }
        
       ShareManager.share.share(object: shareObject, showInController: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.tintColor = .white
        }

        self.tableView.backgroundView = GraphicsSetting.BackgroundColor.setBackgroundView(imageName: "backgroundImage100_flipVertical_black-2")
        self.tableView.backgroundView?.contentMode = .scaleAspectFill

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int!
       
        switch section {
        case 0: rows = 4
        case 1: rows = history.totalCost.count
        case 2: rows = history.resultPair.count
        default:
            rows = 0
        }
        
        return rows
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle[section]
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        if let textLabel = header.textLabel {
            textLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            textLabel.textColor = UIColor.white
            textLabel.textAlignment = .center
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetailedHistory", for: indexPath) as! DetailedHistoryCell
        cell.configureCell(history: history, indexPath: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 30
        
        switch indexPath.section {
        case 0:

            if self.view.bounds.width < 380 {
                if #available(iOS 13.0, *) {
                    if overviewTitle[indexPath.row].count < 10 || history.totalExpenses > 9999999 || history.perPerson > 9999999 {
                        cellHeight = 30
                    } else {
                        cellHeight = CGFloat(overviewTitle[indexPath.row].count) * 2.5 //+ 50
                    }
                }
            } else {
                cellHeight = 30
            }
            
        case 1:
            let nameCount = history.totalCost[indexPath.row].name
            let amount = history.totalCost[indexPath.row].amount
            if history.totalCost[indexPath.row].name.count < 15 {
                cellHeight = 30
            } else {
                if self.view.bounds.width < 380 {
                    if #available(iOS 13.0, *) {
                        cellHeight = CGFloat(nameCount.count) * 3
                    } else {
                        cellHeight = CGFloat(nameCount.count) * 2.5
                    }
                } else {
                    if String(amount!).count < 15 {
                        cellHeight = CGFloat(nameCount.count) * 2 + CGFloat(String(amount!).count)
                    } else {
                        cellHeight = UITableView.automaticDimension //CGFloat(nameCount.count) * 3
                    }
                    
                }
    
            }
        case 2:
            let nameCount = history.resultPair[indexPath.row].debtor + " \u{2192} " + history.resultPair[indexPath.row].creditor
            if nameCount.count < 20 {
                cellHeight = 30
            } else {
                cellHeight =  CGFloat(nameCount.count) * 2.2 //UITableView.automaticDimension + 50
            }
        default:
            cellHeight = UITableView.automaticDimension
        }
        
        return cellHeight
    }

}
