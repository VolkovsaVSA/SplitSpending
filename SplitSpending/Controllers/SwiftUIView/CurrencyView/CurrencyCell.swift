//
//  CurrencyCell.swift
//  Debts
//
//  Created by Sergei Volkov on 10.04.2021.
//

import SwiftUI

struct CurrencyCell: View {
    
    @ObservedObject var currencyListVM: CurrencyViewModel
    
    let item: CurrencyModel

    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.currencyCode)
                    Text("-")
                    Text(item.currencySymbol)
                }
                Text(item.localazedString)
                    .font(.system(size: 14, weight: .light, design: .default))
            }
            .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                
                if currencyListVM.favoritesCurrency.contains(item) {
                    currencyListVM.removeFromFavorites(currency: item)
                } else {
                    currencyListVM.appendToFavorites(currency: item)
                }
                
            }, label: {
                
                Image(systemName: prepareButtonImage())
                    .foregroundColor(currencyListVM.favoritesCurrency.contains(item) ? Color.yellow : Color.white)
            })
            .buttonStyle(PlainButtonStyle())

            
        }
        
    }
    
    private func prepareButtonImage()->String {
        return currencyListVM.favoritesCurrency.contains(item) ? "star.fill" : "star"
    }
}
