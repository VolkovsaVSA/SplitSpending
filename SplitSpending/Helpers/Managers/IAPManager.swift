//
//  IAPManager.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 27/09/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation
import StoreKit
//import Network

class IAPManager: NSObject {
    private override init() {}
    
    static let shared = IAPManager()
    static let getProductNotifID = "getProductNotifID"
    
    enum IAPProducts: String {
        case fullVersion = "003VSA_fullVersion"
        
        enum ProductsState: String {
            case restored = "RestoredParchase"
            case errored = "ErroredPurchase"
            case completed = "CompletedPurchase"
        }
    }
    
    var products: [SKProduct] = []
    let paymentQueue = SKPaymentQueue.default()
    
    func checkFullVersion(rootVC: UIViewController, completion: @escaping(()->Void)) {
        if UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) {
            completion()
        } else {
            AlertManager.buyFullVersionAlert(vc: rootVC, text: LocalizedString.Alert.Text.toUseThisFeaturePurchaseTheFullVersionOfTheProgramFor)
        }
    }
    
    public func setupPurchases(completion: @escaping(Bool)->()) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            completion(true)
            return
        }
        completion(false)
    }
    
    public func getProducts() {
        let identifires: Set = [IAPManager.IAPProducts.fullVersion.rawValue]
        let productRequest = SKProductsRequest(productIdentifiers: identifires)
        productRequest.delegate = self
        productRequest.start()
        print(#function, #line, IAPManager.shared.products.description)
    }
    
    public func priceOfProduct(product: SKProduct) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price)!
    }
    
    public func purshase(productWith identifire: String) {
        guard let product = products.filter({ $0.productIdentifier == identifire }).first else {return}
        let payment = SKPayment(product: product)
        /* платёж за некоторое количество расходуемой покупки
        let payment1 = SKMutablePayment(product: product)
        payment1.quantity = 2
        */
        paymentQueue.add(payment)
        
    }
    
    public func restoreCompletedTransaction() {
        paymentQueue.restoreCompletedTransactions()
    }
     /*
    public func validatePurchases() {
        let receipValidator = ReceiptValidator()
        let result = receipValidator.validateReceipt()
        
        switch result {
        case let .success(receipt):
            //AdMobManager.useAdMob = false
            UserDefaults.standard.set(true, forKey: IAPProducts.fullVersion.rawValue)
            UserDefaults.standard.synchronize()
            print("receipt - \(receipt)")
            
            /* //Валидация для подписки
             guard let purchase = receipt.inAppPurchaseReceipts?.filter({ $0.productIdentifier == "YOUR_Identifire" }).first else {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: transaction.payment.productIdentifier), object: nil)
             paymentQueue.finishTransaction(transaction)
             return
             }
             
             if purchase.subscriptionExpirationDate?.compare(Date()) == .orderedDescending {
             UserDefaults.standard.set(true, forKey: IAPProducts.fullVersion.rawValue)
             UserDefaults.standard.synchronize()
             } else {
             UserDefaults.standard.set(false, forKey: IAPProducts.fullVersion.rawValue)
             UserDefaults.standard.synchronize()
             }
             */
            
        case let .error(error):
            print(error.localizedDescription)
            UserDefaults.standard.set(false, forKey: IAPProducts.fullVersion.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    */
    
//    public func startCheckInternetConnection(_ handler: () -> Void) {
//        if #available(iOS 12.0, *) {
//            let monitor = NWPathMonitor()
//            let queue = DispatchQueue(label: "InternetMonitor")
//            monitor.pathUpdateHandler = { [weak self] path in
//                if path.status == .satisfied {
//                    print("internet on")
//                    self?.validatePurchases()
//                } else {
//                    print("internet off")
//                    //NotificationCenter.default.post(name: NSNotification.Name(IAPProducts.ProductsState.errored.rawValue), object: nil)
//                }
//            }
//            monitor.start(queue: queue)
//        } else {
//            IAPManager.shared.getProducts()
//            if IAPManager.shared.products.count > 0 {
//                validatePurchases()
//            }
//        }
//    }
    
//    public func stopCheckInternetConnection() {
//        if #available(iOS 12.0, *) {
//            let monitor = NWPathMonitor()
//             monitor.cancel()
//        }
//    }

    
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred: break
            case .purchasing: break
            case .failed: faild(transaction: transaction)
            case .purchased: completed(transaction: transaction)
            case .restored: restored(transaction: transaction)
            @unknown default:
                break
            }
        }
    }
    
    private func faild(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("transaction error \(transactionError.localizedDescription)")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPProducts.ProductsState.errored.rawValue), object: nil)
            }
        }
        paymentQueue.finishTransaction(transaction)
    }
    private func completed(transaction: SKPaymentTransaction) {
        UserDefaults.standard.set(true, forKey: IAPProducts.fullVersion.rawValue)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(IAPProducts.ProductsState.completed.rawValue), object: nil)
        paymentQueue.finishTransaction(transaction)
    }
    private func restored(transaction: SKPaymentTransaction) {
        UserDefaults.standard.set(true, forKey: IAPProducts.fullVersion.rawValue)
        UserDefaults.standard.synchronize()
        //validatePurchases()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPProducts.ProductsState.restored.rawValue), object: nil)
        paymentQueue.finishTransaction(transaction)
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
//        if products.count > 0 {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPManager.getProductNotifID), object: nil)
//        }
    }
}
