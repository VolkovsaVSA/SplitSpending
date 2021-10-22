//
//  Calculate.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 26/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit

class Calculate: UIViewController {

    
    var totalCostDictCalculate: [Int: Debt]?
    private var numberOfPerson: Int?
    private var totalExpenses: Float?
    private var perPerson: Float?
    
    @IBOutlet weak var calculateTV: UITableView!
    @IBOutlet weak var perPersonLabel: UILabel!
    @IBOutlet weak var numberOfPersonLabel: UILabel!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var shareBTN: UIButton!
    
    @IBAction func shareBTNAction(_ sender: UIButton) {
        
        guard ResultPair.count != 0 else {return}
        
        var shareObject = [String]()
        
        if let totalExpensesLocal = totalExpenses, let numberOfPersonLocal = numberOfPerson, let perPersonLocal = perPerson {
            shareObject.append(LocalizedString.date + ": " + MyDateFormatter.formatter(dateStyle: .medium, timeStyle: .short).string(from: Date()))
            
            if let costDict = totalCostDictCalculate {
                costDict.forEach { item in
                    shareObject.append(item.value.name + ": " + Currency.currencyFormatter(currency: Decimal(Double(item.value.amount ?? 0)), currencyCode: CurrencyViewModel.shared.selectedCurrency.currencyCode, showCode: CurrencyViewModel.shared.showCurrencyCode)
                    )
                }
            }
            shareObject.append(" ")
            shareObject.append(LocalizedString.ShareMessage.totalExpenses + ": "
                               + Currency.currencyFormatter(currency: Decimal(Double(totalExpensesLocal)),
                                                            currencyCode: CurrencyViewModel.shared.selectedCurrency.currencyCode,
                                                            showCode: CurrencyViewModel.shared.showCurrencyCode)
            )
            shareObject.append(LocalizedString.ShareMessage.numberOfPersons + ": " + numberOfPersonLocal.description)
            shareObject.append(LocalizedString.ShareMessage.expensesPerPerson + ": "
                               + Currency.currencyFormatter(currency: Decimal(Double(perPersonLocal)), currencyCode: CurrencyViewModel.shared.selectedCurrency.currencyCode, showCode: CurrencyViewModel.shared.showCurrencyCode) + "\n"
            )
            shareObject.append(LocalizedString.ShareMessage.payouts + ":")
        }
        
        for object in ResultPair {
            
            let payment = "\(object.debtor) \u{2192} \(object.creditor) \(Currency.currencyFormatter(currency: Decimal(Double(object.payment)), currencyCode: CurrencyViewModel.shared.selectedCurrency.currencyCode, showCode: CurrencyViewModel.shared.showCurrencyCode))."
            
            shareObject.append(payment)
        }
        
        
        if UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) {
            ShareManager.share.share(object: shareObject, showInController: self)
        } else {
            AlertManager.buyFullVersionAlert(vc: self, text: LocalizedString.Alert.Text.toUseThisFeaturePurchaseTheFullVersionOfTheProgramFor)
        }
        
//        ShareManager.share.share(object: shareObject, showInController: self)


    }
        
    @IBAction func backBTNAction(_ sender: UIButton) {
        
        AlertManager.twoButtonAlert(title: LocalizedString.Alert.Title.history,
                                    text: LocalizedString.Alert.Text.doYouWantSaveThisCalculation,
                                    buttonActionText: LocalizedString.Alert.Button.save,
                                    buttonActionStyle: .destructive,
                                    presentVC: self) { _ in
            
            self.addToHistoryArr()
            SaveLoadManager.saveHistory()
            self.dismissController()
        } cancelActionHandler: { _ in
            self.dismissController()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GraphicsSetting.Dimension.cornerRadius(view: [backBTN, shareBTN], cornerRadius: 8)
        addBanner()
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        prepareData()
    }
    
    
    private func addToHistoryArr() {
        var tempTotalCostDict = [Debt]()
        totalCostDictCalculate?.forEach({ (_, value: Debt) in
            tempTotalCostDict.append(value)
        })
        HistoryArr.append(HistoryModel(totalExpenses: totalExpenses!, numberOfPerson: numberOfPerson!, perPerson: perPerson!, resultPair: ResultPair, date: Date(), totalCost: tempTotalCostDict, currency: CurrencyViewModel.shared.selectedCurrency.currencyCode))
    }
    private func dismissController() {
        totalCostDictCalculate = [:]
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func purchaseCompleted() {
        AlertManager.presentInfoAlert(
            title: LocalizedString.Alert.Title.purchase,
            text: LocalizedString.Alert.Text.purchaseConfirmed,
            buttonText: LocalizedString.Alert.Button.ok,
            presentVC: self)
    }
    @objc func purchaseRestored() {
        //RemoveActivityIndicator(presentView: self.view)
        AlertManager.presentInfoAlert(
            title: LocalizedString.Alert.Title.purchase,
            text: LocalizedString.Alert.Text.purchaserestored,
            buttonText: LocalizedString.Alert.Button.ok,
            presentVC: self)
    }
    @objc func purchaseErrored() {
        //RemoveActivityIndicator(presentView: self.view)
        AlertManager.presentInfoAlert(
            title: LocalizedString.Alert.Title.error,
            text: LocalizedString.Alert.Text.somethingWentWrong,
            buttonText: LocalizedString.Alert.Button.ok,
            presentVC: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func calculatePerPerson(dict: [Int: Debt]) -> Float {
        let totalExpenses = calcTotalExpenses(dict: dict)
        
        if dict.count == 0 {
            return 0
        } else {
            return round(totalExpenses/Float(dict.count) * 100) / 100
        }
    }
    private func calcTotalExpenses(dict: [Int: Debt])->Float {
        var summ: Float = 0
        
        for (_, value) in dict.enumerated() {
            if let amount = value.value.amount {
                summ += amount
            }
        }
        return summ
    }
    private func prepareData() {
        if let dict = totalCostDictCalculate {
            perPerson = calculatePerPerson(dict: dict)
            let perPersonDecimal = Decimal(Double(perPerson ?? 0))
            numberOfPerson = dict.count
            totalExpenses = calcTotalExpenses(dict: dict)
            let totalExpensesDecimal = Decimal(Double(totalExpenses ?? 0))
            totalExpensesLabel.text = Currency.currencyFormatter(currency: totalExpensesDecimal,
                                                                 currencyCode: CurrencyViewModel.shared.selectedCurrency.currencyCode,
                                                                 showCode: CurrencyViewModel.shared.showCurrencyCode)
            
            numberOfPersonLabel.text = numberOfPerson?.description

            perPersonLabel.text = Currency.currencyFormatter(currency:perPersonDecimal,
                                                             currencyCode: CurrencyViewModel.shared.selectedCurrency.currencyCode,
                                                             showCode: CurrencyViewModel.shared.showCurrencyCode)
            
            calc(dict: dict)
        }
    }
    private func addBanner() {
        if UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) {
            AdMobManager.shared.removeBanner(presentView: self.view)
            calculateTV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        } else {
            calculateTV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
            AdMobManager.shared.createBanner(heightBanner: 80, presentVC: self)
            
        }
    }
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseCompleted), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.completed.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseRestored), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.restored.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseErrored), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.errored.rawValue), object: nil)
    }
    private func setBlur(views: [UIButton]) {
        
        views.forEach { object in
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.isUserInteractionEnabled = false
            blurEffectView.frame = object.bounds
            object.layer.cornerRadius = 8
            object.backgroundColor = .clear
            object.addSubview(blurEffectView)
            object.clipsToBounds = true
        }
    }
    
    
    private func calc(dict: [Int: Debt]) {
        var pendArr = [PendingModel]()
        ResultPair = []
        let perPerson = round(calculatePerPerson(dict: dict) * 100) / 100
        
        dict.forEach { (dictItem) in
            
            if let amount = dictItem.value.amount {
                let difference = round((perPerson - amount) * 100) / 100
                pendArr.append(PendingModel(name: dictItem.value.name, amount: amount, difference: difference))
            }
            
        }
        
        func calcPend() {
            
            guard pendArr.count > 0 else {return}
            
            var sortPendArr = pendArr.sorted {$0.difference < $1.difference}
            var firstCreditor = sortPendArr.first
            var firstDebtor = sortPendArr.last
            
            guard (firstCreditor != nil) && (firstDebtor != nil) else {print("guard", #function, #line); return}
            
            while round(firstCreditor!.difference * 10) / 10 != 0 /*firstCreditor!.difference != 0*/ {
                
                let credDiff = abs(firstCreditor!.difference)
                
                if credDiff > firstDebtor!.difference {
                
                    var newCredDiff = round((firstCreditor!.difference + firstDebtor!.difference) * 100) / 100
                    var debtPending = firstDebtor!.difference
                    
                    if newCredDiff == -0.01 {
                        newCredDiff = 0
                        debtPending = round((firstDebtor!.difference + 0.01) * 100) / 100
                    }
                    
                    for (pendIndex, pendValue) in pendArr.enumerated() {
                        switch pendValue.name {
                        case firstDebtor!.name: pendArr[pendIndex].difference = 0
                        case firstCreditor!.name: pendArr[pendIndex].difference = newCredDiff
                        default: break
                        }
                    }
                    ResultPair.append(ResultPairModel(debtor: firstDebtor!.name, creditor: firstCreditor!.name, payment: debtPending))
                } else {
                    var newDebtDiff = round((firstDebtor!.difference + firstCreditor!.difference) * 100) / 100
                    var debtPending = credDiff
                    
                    if newDebtDiff == 0.01 {
                        newDebtDiff = 0
                       debtPending = round((debtPending + 0.01) * 100) / 100
                    }
                    
                    for (pendIndex, pendValue) in pendArr.enumerated() {
                        switch pendValue.name {
                        case firstDebtor!.name: pendArr[pendIndex].difference = newDebtDiff
                        case firstCreditor!.name: pendArr[pendIndex].difference = 0
                        default: break
                        }
                    }
                    ResultPair.append(ResultPairModel(debtor: firstDebtor!.name, creditor: firstCreditor!.name, payment: debtPending))
                }
                
                sortPendArr = pendArr.sorted {$0.difference < $1.difference}
                firstCreditor = sortPendArr.first
                firstDebtor = sortPendArr.last
            }
            //end while
            
        }
        
        calcPend()
    }
    
    
}

extension Calculate: UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResultPair.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalculateCell", for: indexPath) as! CalculateCell
        cell.configureCell(indexPath: indexPath, resultPair: ResultPair)
        return cell
    }
}



