//
//  AlertManager.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 21/09/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import Foundation
import UIKit

struct AlertManager {
    private init() {}
    static func presentInfoAlert(title: String, text: String, buttonText: String, presentVC: UIViewController) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: buttonText, style: .cancel, handler: nil)
        alert.addAction(alertOkAction)
        presentVC.present(alert, animated: true, completion: nil)
    }
    
    static func twoButtonAlert(title: String, text: String, buttonActionText: String, buttonActionStyle: UIAlertAction.Style, presentVC: UIViewController, buttonActionHandler: @escaping((UIAlertAction)->Void), cancelActionHandler: @escaping((UIAlertAction)->Void)) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let secondButtonAction = UIAlertAction(title: LocalizedString.Alert.Button.cancel, style: .cancel, handler: cancelActionHandler)
        let firstButtonAction = UIAlertAction(title: buttonActionText, style: buttonActionStyle, handler: buttonActionHandler)
        alert.addAction(firstButtonAction)
        alert.addAction(secondButtonAction)
        presentVC.present(alert, animated: true, completion: nil)
    }
    
    static func buyFullVersionAlert(vc: UIViewController, text: String) {
        IAPManager.shared.getProducts()
        
        if IAPManager.shared.products.count > 0 {
            let productFullVersion = IAPManager.shared.products[0]

            AlertManager.twoButtonAlert(title: LocalizedString.Alert.Title.attention,
                                        text: text + " " + IAPManager.shared.priceOfProduct(product: productFullVersion),
                                        buttonActionText: LocalizedString.Alert.Button.buy,
                                        buttonActionStyle: .destructive,
                                        presentVC: vc) { _ in
                IAPManager.shared.getProducts()
                let productFullVersion = IAPManager.shared.products[0]
                IAPManager.shared.purshase(productWith: productFullVersion.productIdentifier)
            } cancelActionHandler: {_ in}

            
        } else {
            AlertManager.presentInfoAlert(title: LocalizedString.Alert.Title.error, text: LocalizedString.Alert.Text.noInternetConnectionToBuyTheFullVersionOfTheApplication, buttonText: LocalizedString.Alert.Button.ok, presentVC: vc)
        }
        
    }
    
    
}
