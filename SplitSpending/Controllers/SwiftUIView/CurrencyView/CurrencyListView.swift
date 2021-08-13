//
//  CurrencyView.swift
//  Debts
//
//  Created by Sergei Volkov on 10.04.2021.
//

import SwiftUI
import UIKit

struct CurrencyListView: View {
    
    var dismiss: (() -> Void)
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var currencyListVM = CurrencyViewModel.shared
    
    var body: some View {
        
        List {
            Section(header: Text("Favorites").foregroundColor(.white)) {
                ForEach(currencyListVM.favoritesCurrency, id:\.self) { item in
                    currencyButton(item)
                        .listRowBackground(Color.black.opacity(0.3))
                }
            }
            Section(header: Text("All currencies").foregroundColor(.white)) {
                ForEach(currencyListVM.allCurrency, id:\.self) { item in
                    currencyButton(item)
                        .listRowBackground(Color.black.opacity(0.3))
                }
            }

        }
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor.clear
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(NSLocalizedString("Currency", comment: "navBarTitle"))
        .navigationBarTitleDisplayMode(.automatic)
        
    }
    
    private func currencyButton(_ item: CurrencyModel) -> some View {
        return Button(action: {
            currencyListVM.selectedCurrency = item
            dismiss()
            print(currencyListVM.selectedCurrency.currencyCode)
        }, label: {
            CurrencyCell(currencyListVM: currencyListVM, item: item)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

