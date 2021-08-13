//
//  ChooseCurrency.swift
//  ChooseCurrency
//
//  Created by Sergei Volkov on 28.07.2021.
//  Copyright © 2021 Sergey Volkov. All rights reserved.
//

import SwiftUI

struct ChooseCurrency: View {
    
    var dismiss: (() -> Void)
    
    var body: some View {

        NavigationView {
            CurrencyListView(dismiss: dismiss)
                .background(Image("backgroundImage100_flipVertical_black-2"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .colorScheme(.dark)
        
        
    }
}
