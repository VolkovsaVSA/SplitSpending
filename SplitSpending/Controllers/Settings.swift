//
//  Settings.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 19/09/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit
import SwiftUI
import MessageUI

class Settings: UITableViewController {
    
    @IBOutlet weak var buyFullVersionBTN: UIButton!
    @IBOutlet weak var restorePurchasesBTN: UIButton!
    @IBOutlet weak var loadDataBTN: UIButton!
    @IBOutlet weak var saveDataBTN: UIButton!
    @IBOutlet weak var backupToIcloudSwitch: UISwitch!
    @IBOutlet weak var backupAvilableLabel: UILabel!
    @IBOutlet weak var currencyBTN: UIButton!
    @IBOutlet weak var showCurrencySwitch: UISwitch!
    
    @IBOutlet weak var chooseCurrencyTVC: UITableViewCell!
    @IBOutlet var mainTV: UITableView!
    
    
    @IBAction func shoCurrencySwitchAction(_ sender: UISwitch) {
        CurrencyViewModel.shared.showCurrencyCode = sender.isOn
    }
    
    @IBAction func chooseCurrencyAction(_ sender: UIButton) {
        
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
    @IBAction func otherAppsAction(_ sender: UIButton) {
        if let url = URL(string: "https://apps.apple.com/developer/sergei-volkov/id1385708952") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        //https://apps.apple.com/us/developer/sergei-volkov/id1385708952
    }
    
    
    @IBAction func byFullVersionBTNAction(_ sender: UIButton) {
        
        if IAPManager.shared.products.count > 0 {
            let productFullVersion = IAPManager.shared.products[0]
            AlertManager.twoButtonAlert(
                title: LocalizedString.Alert.Title.purchase,
                text: LocalizedString.Alert.Text.fullStringByFullVersion + " " + LocalizedString.Alert.Text.buyTheFullVersionFor + " " + IAPManager.shared.priceOfProduct(product: productFullVersion),
                buttonActionText: LocalizedString.Alert.Button.buy,
                buttonActionStyle: .destructive,
                presentVC: self) { action in
                    IAPManager.shared.purshase(productWith: productFullVersion.productIdentifier)
                } cancelActionHandler: {_ in}
        } else {
            AlertManager.presentInfoAlert(
                title: LocalizedString.Alert.Title.error,
                text: LocalizedString.Alert.Text.somethingWentWrong,
                buttonText: LocalizedString.Alert.Button.ok, presentVC: self)
        }
    }
    @IBAction func restorePurchasesBTNAction(_ sender: UIButton) {
        IAPManager.shared.restoreCompletedTransaction()
    }
    @IBAction func backupToIcloudSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.attention, text: LocalizedString.Alert.Text.backupAutomaticalyAttention, buttonText: LocalizedString.Alert.Button.ok, presentVC: self)
            UserDefaults.standard.set(true, forKey: UDKeys.backupToIcloudAutomaticaly.rawValue)
        } else {
            UserDefaults.standard.set(false, forKey: UDKeys.backupToIcloudAutomaticaly.rawValue)
        }
    }
    @IBAction func loadDataBTNAction(_ sender: UIButton) {
        
        ICloudManager.loadFromIcloud(localPath: SaveLoadManager.PathForSave.history, fileName: ICloudManager.ICloudFolder.ICLoudfileName.history.rawValue) {  [weak self] loadFromIcloudError in
            
            guard let self = self else {return}
            ICloudManager.ICloudError.errorHandling(error: loadFromIcloudError, vc: self, type: .load)
            
            if loadFromIcloudError == nil {
                SaveLoadManager.loadHistory()
            }
        }

    }
    @IBAction func saveDataBTNAction(_ sender: UIButton) {
        ICloudManager.copyFileToICloud(localPath: SaveLoadManager.PathForSave.history, fileName: ICloudManager.ICloudFolder.ICLoudfileName.history.rawValue) { [weak self] error in
            
            guard let self = self else {return}
            ICloudManager.ICloudError.errorHandling(error: error, vc: self, type: .save)
        }
    }
    @IBAction func backBTNAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendEmailAction(_ sender: UIButton) {
               
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            composeVC.setToRecipients([AppId.feedbackEmail])
            composeVC.setSubject(LocalizedString.Email.Subject.feedbackOnApplication)
            composeVC.setMessageBody("\n\n\n\n\(LocalizedString.Email.MessageBody.sentFromTheSplitSpendingApp) \(AppId.appHttp)", isHTML: false)
            present(composeVC, animated: true, completion: nil)
            
        } else {
            AlertManager.presentInfoAlert(
                title: LocalizedString.Alert.Title.error,
                text: LocalizedString.Alert.Text.mailServicesAreNotAvailable,
                buttonText: LocalizedString.Alert.Button.ok,
                presentVC: self)
            return
        }
        
    }
    @IBAction func rateAppAction(_ sender: UIButton) {
        if let url = AppId.appUrl {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setCurrencyBTNTitle()
        showCurrencySwitch.isOn = CurrencyViewModel.shared.showCurrencyCode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareVisualElements()
        addNotificationObserver()
        
        if UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) {
            fullversionElemntsOn()
        } else {
            fullversionElemntsOff()
        }

        
    }
    
    @objc func purchaseCompleted() {
        //RemoveActivityIndicator(presentView: self.view)
        AlertManager.presentInfoAlert(
            title: LocalizedString.Alert.Title.purchase,
            text: LocalizedString.Alert.Text.purchaseConfirmed,
            buttonText: LocalizedString.Alert.Button.ok,
            presentVC: self)
        fullversionElemntsOn()
        SaveLoadManager.loadHistory()
    }
    @objc func purchaseRestored() {
        //RemoveActivityIndicator(presentView: self.view)
        AlertManager.presentInfoAlert(
            title: LocalizedString.Alert.Title.purchase,
            text: LocalizedString.Alert.Text.purchaserestored,
            buttonText: LocalizedString.Alert.Button.ok,
            presentVC: self)
        fullversionElemntsOn()
        SaveLoadManager.loadHistory()
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        if let textLabel = header.textLabel {
            textLabel.font = UIFont.boldSystemFont(ofSize: 17)
            textLabel.textColor = UIColor.lightGray
            textLabel.textAlignment = .center
        }
    }
    private func setCurrencyBTNTitle() {
        let code = CurrencyViewModel.shared.selectedCurrency.currencyCode
        let symbol = CurrencyViewModel.shared.selectedCurrency.currencySymbol
        let descrption = CurrencyViewModel.shared.selectedCurrency.localazedString
        
        let attString = NSMutableAttributedString()
        attString.append(NSAttributedString(string: "\(code) - \(symbol)\n",
                                            attributes: [:]))
        attString.append(NSAttributedString(string: descrption,
                                            attributes: [
                                                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .light),
                                            ]))
        
        currencyBTN.titleLabel?.numberOfLines = 2
        currencyBTN.setAttributedTitle(attString, for: .normal)
    }
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseCompleted), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.completed.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseRestored), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.restored.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseErrored), name: NSNotification.Name(IAPManager.IAPProducts.ProductsState.errored.rawValue), object: nil)
    }
    private func prepareVisualElements() {
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.tintColor = .white
        }
        self.tableView.backgroundView = GraphicsSetting.BackgroundColor.setBackgroundView(imageName: "backgroundImage100_flipVertical_black-2")
        self.tableView.backgroundView?.contentMode = .scaleAspectFill
        GraphicsSetting.Dimension.cornerRadius(view: [buyFullVersionBTN, restorePurchasesBTN, loadDataBTN, saveDataBTN], cornerRadius: 10)
        
        if UserDefaults.standard.bool(forKey: UDKeys.backupToIcloudAutomaticaly.rawValue){
            backupToIcloudSwitch.isOn = true
        } else {
            backupToIcloudSwitch.isOn = false
        }
        
        overrideUserInterfaceStyle = .dark
    }
    private func fullversionElemntsOn() {
        loadDataBTN.isEnabled = true
        saveDataBTN.isEnabled = true
        loadDataBTN.alpha = 1
        saveDataBTN.alpha = 1
        backupAvilableLabel.isHidden = true
        backupToIcloudSwitch.isEnabled = true
    }
    private func fullversionElemntsOff() {
        loadDataBTN.isEnabled = false
        saveDataBTN.isEnabled = false
        loadDataBTN.alpha = 0.5
        saveDataBTN.alpha = 0.5
        backupAvilableLabel.isHidden = false
        backupToIcloudSwitch.isEnabled = false
    }

}

extension Settings: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

@available(iOS 12.0, *)
private func modeDetect(userInterfaceStyle: UIUserInterfaceStyle, vc: UIViewController) {
    switch userInterfaceStyle {
    case .light:
        vc.navigationController?.navigationBar.barTintColor = .white
    case .dark:
        vc.navigationController?.navigationBar.barTintColor = .black
    default:
        break
    }
}

