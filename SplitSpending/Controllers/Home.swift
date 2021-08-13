//
//  Home.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 15/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import SwiftUI
import UIKit
import Contacts
import ContactsUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import MathExpression

class Home: UIViewController, CNContactPickerDelegate {
    
    private var mainTVBottonConstraint: NSLayoutConstraint!
    
    private var totalPerson: Int = 0
    private var personArr = [(person: String, amount: Double)]()
    private var totalCostDict = [Int: Debt]()
    
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var mainTV: UITableView!

    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var buttonMore: UIButton!
    
    
    @IBAction func button2Action(_ sender: UIButton) {
        GraphicsSetting.BackgroundColor.setBackgroundColor(view: [button2], backgroundColor: UIColor.white.cgColor, alpha: 0.5)
        GraphicsSetting.BackgroundColor.setBackgroundColor(view: [button3, button4, buttonMore], backgroundColor: UIColor.clear.cgColor, alpha: 0)
        totalPerson = 2
        recalCulateTotalCost(totalCostDict: &totalCostDict, totalPerson: totalPerson)
        mainTV.reloadData()
        
        CorrectionKeyboardFrame(vc: self, totalPerson: totalPerson)
    }
    @IBAction func button3Action(_ sender: UIButton) {
        GraphicsSetting.BackgroundColor.setBackgroundColor(view: [button2, button3], backgroundColor: UIColor.white.cgColor, alpha: 0.5)
        GraphicsSetting.BackgroundColor.setBackgroundColor(view: [button4, buttonMore], backgroundColor: UIColor.clear.cgColor, alpha: 0)
        totalPerson = 3
        recalCulateTotalCost(totalCostDict: &totalCostDict, totalPerson: totalPerson)
        mainTV.reloadData()
        
        CorrectionKeyboardFrame(vc: self, totalPerson: totalPerson)
    }
    @IBAction func button4Action(_ sender: UIButton) {
        GraphicsSetting.BackgroundColor.setBackgroundColor(view: [button2, button3, button4], backgroundColor: UIColor.white.cgColor, alpha: 0.5)
        GraphicsSetting.BackgroundColor.setBackgroundColor(view: [buttonMore], backgroundColor: UIColor.clear.cgColor, alpha: 0)
        totalPerson = 4
        recalCulateTotalCost(totalCostDict: &totalCostDict, totalPerson: totalPerson)
        mainTV.reloadData()
        
        CorrectionKeyboardFrame(vc: self, totalPerson: totalPerson)
    }
    @IBAction func buttonMoreAction(_ sender: UIButton) {
        
        let totalPersonAlert = UIAlertController(title: LocalizedString.Alert.Text.enterTheNumberOfPerson, message: nil, preferredStyle: .alert)
        totalPersonAlert.addTextField { (totalTF) in
            totalTF.placeholder = LocalizedString.Alert.Placeholder.numberOfPerson
            totalTF.keyboardType = .numberPad
        }
        
        let totalPersonOkAction = UIAlertAction(title: LocalizedString.Alert.Button.ok, style: .default) { (action) in
            guard let numberOfPerson = Int(totalPersonAlert.textFields![0].text!) else {return}
            self.totalPerson = numberOfPerson
            
            GraphicsSetting.BackgroundColor.setBackgroundColor(view: [self.button2, self.button3, self.button4, self.buttonMore], backgroundColor: UIColor.white.cgColor, alpha: 0.5)
            GraphicsSetting.BackgroundColor.setBackgroundColor(view: [], backgroundColor: UIColor.clear.cgColor, alpha: 0)
            self.recalCulateTotalCost(totalCostDict: &self.totalCostDict, totalPerson: self.totalPerson)
            self.mainTV.reloadData()
            
            CorrectionKeyboardFrame(vc: self, totalPerson: self.totalPerson)
        }
        
        let totalPersonCancelAction = UIAlertAction(title: LocalizedString.Alert.Button.cancel, style: .destructive, handler: nil)
        totalPersonAlert.addAction(totalPersonOkAction)
        totalPersonAlert.addAction(totalPersonCancelAction)

//        self.present(totalPersonAlert, animated: true, completion: nil)
        
        IAPManager.shared.checkFullVersion(rootVC: self) {
            self.present(totalPersonAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBOutlet weak var calculateBTN: UIButton!
    @IBAction func calculateBTNAction(_ sender: UIButton) {
        if !UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) {
            AdMobManager.shared.showInterstitialAds(inRootViewController: self)
        }

        var flag = true
        
        totalCostDict.forEach { (data) in
            if data.value.name == "" {
                flag = false
            }
        }
        
        if (totalCostDict.count > 1) && flag {
            performSegue(withIdentifier: "CalculateSegue", sender: self)
        } else {
            AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.error, text: LocalizedString.Alert.Text.fillInAllTheFelds, buttonText: LocalizedString.Alert.Button.ok, presentVC: self)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recalculateTotalLabel(label: totalCostLabel, totalCostDict: totalCostDict)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        AdMobManager.shared.requestInterstitialAds(rootVC: self)
        prepareButtons()
        addNotificationObserver()
        SaveLoadManager.loadHistory()
        addBanner()
        
        totalCostLabel.isUserInteractionEnabled = true
        totalCostLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchTotalCostLabel(_:))))
    }
    
    @objc func touchTotalCostLabel(_ sender: UITapGestureRecognizer) {
        
        IAPManager.shared.checkFullVersion(rootVC: self) {
            let vc = UIHostingController(rootView: ChooseCurrency(dismiss: {self.dismiss( animated: true, completion: nil )}))
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
//
//        let vc = UIHostingController(rootView: ChooseCurrency(dismiss: {self.dismiss( animated: true, completion: nil )}))
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
    }

    @objc func purchaseCompleted() {
        //RemoveActivityIndicator(presentView: self.view)
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
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseCompleted), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.completed.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseRestored), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.restored.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseErrored), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.errored.rawValue), object: nil)
    }
    private func addBanner() {
        if UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) {
            AdMobManager.shared.removeBanner(presentView: self.view)
            mainTV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        } else {
            mainTV.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
            AdMobManager.shared.createBanner(heightBanner: 80, presentVC: self)
        }
    }
    private func prepareButtons() {
        GraphicsSetting.Dimension.cornerRadius(view: [button2, button3, button4, buttonMore], cornerRadius: 25)
        GraphicsSetting.Dimension.cornerRadius(view: [calculateBTN], cornerRadius: 12)
        GraphicsSetting.Dimension.borderWidth(view: [button2, button3, button4, buttonMore], borderWidth: 0.3)
        GraphicsSetting.Dimension.borderWidth(view: [calculateBTN], borderWidth: 0.7)
        calculateBTN.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CalculateSegue" {
            let vc = segue.destination as! Calculate
            vc.totalCostDictCalculate = totalCostDict
        }
        if segue.identifier == "HistorySegue" {
//            IAPManager.shared.checkFullVersion(rootVC: self) {}
        }
        
    }

    
    private func recalCulateTotalCost(totalCostDict: inout [Int: Debt], totalPerson: Int) {
        let tempTotalCostDict = totalCostDict
        
        if totalCostDict.count > totalPerson {
            totalCostDict = [:]
            for tag in 0...totalPerson - 1 {
                totalCostDict[tag] = tempTotalCostDict[tag]
            }
        }
        
        recalculateTotalLabel(label: totalCostLabel, totalCostDict: totalCostDict)
    }
    
    private func recalculateTotalLabel(label: UILabel, totalCostDict: [Int: Debt]) {
        var total: Float = 0
        for (_, value) in totalCostDict.enumerated() {
            if let amount = value.value.amount {
                total += amount
            }
        }
        
        let dec = Decimal(Double(total))
        label.text = Currency.currencyFormatter(currency: dec,
                                                currencyCode: CurrencyViewModel.shared.selectedCurrency.currencyCode,
                                                showCode: CurrencyViewModel.shared.showCurrencyCode)
    }

}

extension Home: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalPerson
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! HomeCell
        
        cell.configureCell(indexPath: indexPath, totalCostDict: totalCostDict)
        cell.amountOfPerson.tag = indexPath.row
        cell.amountOfPerson.addTarget(self, action: #selector(amountOfPersonTFDidChange(sender:)), for: .editingChanged)
        cell.nameOfPerson.tag = indexPath.row
        cell.nameOfPerson.addTarget(self, action: #selector(nameOfPersonTFEndChange(sender:)), for: .editingDidEnd)
        cell.contactBTN.tag = indexPath.row
        cell.contactBTN.addTarget(self, action: #selector(contactBTNAction(sender:)), for: .touchUpInside)
        
        cell.amountOfPerson.delegate = self
        cell.nameOfPerson.delegate = self
        
        return cell
    }

    @objc func amountOfPersonTFDidChange(sender: UITextField) {
        guard let txt = sender.text else {return}
        var amountFloat: Float = 0
        let amount = txt.replacingOccurrences(of: ",", with: ".")
        
        
        if let expression = try? MathExpression(amount) {
            let value = expression.evaluate()
            amountFloat = round(Float(value) * 100) / 100
        }
        
        if var tempData = totalCostDict[sender.tag] {
            tempData.amount = amountFloat
            totalCostDict[sender.tag] = tempData
        } else {
            totalCostDict[sender.tag] = Debt(name: LocalizedString.nameOfPerson + " " + String(sender.tag + 1), amount: amountFloat)
        }
        
        recalculateTotalLabel(label: totalCostLabel, totalCostDict: totalCostDict)
    }
    
    
    @objc func nameOfPersonTFEndChange(sender: UITextField) {
        guard let name = sender.text else {return}
        
        if var tempData = totalCostDict[sender.tag] {
            tempData.name = name
            totalCostDict[sender.tag] = tempData
        } else {
            totalCostDict[sender.tag] = Debt(name: name, amount: 0)
        }
        
    }
    
    @objc func contactBTNAction(sender: UIButton) {
        
        ContactProvider.indexPress = sender.tag
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self

        IAPManager.shared.checkFullVersion(rootVC: self) {
            self.present(contactPicker, animated: true, completion: nil)
        }
        
    }

    func contactPicker (_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        ContactProvider.contactName = ContactProvider.contactFormatter(contact: contact)
        if let index = ContactProvider.indexPress {
            totalCostDict[index] = Debt(name: ContactProvider.contactName ?? "", amount: nil)
        }
        mainTV.reloadData()
    }
    
}

extension Home {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension Home: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        AdMobManager.shared.requestInterstitialAds(rootVC: self)
        performSegue(withIdentifier: "CalculateSegue", sender: self)
    }
}

extension AdMobManager: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
    }
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}

