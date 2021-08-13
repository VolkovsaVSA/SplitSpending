//
//  CurrencyListViewModel.swift
//  Debts
//
//  Created by Sergei Volkov on 11.04.2021.
//

import Foundation
import SwiftUI

class CurrencyViewModel: ObservableObject {
    
    static let shared = CurrencyViewModel()
    
    @Published var favoritesCurrency = Currency.AllCurrency.favoritescurrency
    @Published var allCurrency = Currency.AllCurrency.allcurrencys
    @Published var selectedCurrency = Currency.CurrentLocal.localCurrency
    
    @Published var showCurrencyCode = false
    
    func appendToFavorites(currency: CurrencyModel) {
        if !favoritesCurrency.contains(currency) {
            favoritesCurrency.append(currency)
            saveFavoritesToUD()
        }
    }
    func removeFromFavorites(currency: CurrencyModel) {
        if favoritesCurrency.contains(currency) {
            for (index, value) in favoritesCurrency.enumerated() {
                if value == currency {
                    favoritesCurrency.remove(at: index)
                }
            }
            saveFavoritesToUD()
        }
    }
    
    func currencyConvert(amount: Decimal, currencyCode: String) -> String {
        return Currency.currencyFormatter(currency: amount,
                                          currencyCode: currencyCode,
                                          showCode: showCurrencyCode)
    }
    
    func saveFavoritesToUD() {
        var currencysCode = [String]()
        favoritesCurrency.forEach { curr in
            currencysCode.append(curr.currencyCode)
        }
        UserDefaults.standard.set(currencysCode, forKey: UDKeys.favoritesCurrency.rawValue)
    }
    func loadFavoritesFromUD() {
        var currencyes = [CurrencyModel]()
        if let currencysCode = UserDefaults.standard.object(forKey: UDKeys.favoritesCurrency.rawValue) as? [String] {
            currencysCode.forEach { curr in
                currencyes.append(Currency.presentCurrency(code: curr))
            }
        }
        favoritesCurrency = currencyes
    }
}
