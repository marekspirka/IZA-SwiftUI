//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentTab: String = "My account"
    
    var body: some View{
        TabView(selection: $currentTab){
            
            BankAccountView()
                .tag("My account")
                .tabItem{
                    Image(systemName: "creditcard.circle")
                    Text("My account")
                }
            ExpensesView(currentTable: $currentTab)
                .tag("Expenses")
                .tabItem{
                    Image(systemName: "arrow.down.right.circle.fill")
                    Text("Expenses")
                }
            EarningsView(currentTable: $currentTab)
                .tag("Earnings")
                .tabItem{
                    Image(systemName: "arrow.up.forward.circle.fill")
                    Text("Earnings")
                }
            CategoryView()
                .tag("Categories")
                .tabItem{
                    Image(systemName: "text.justify")
                    Text("Categories")
                }
            SettingsView()
                .tag("Settings")
                .tabItem{
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}


#Preview {
    ContentView()
}
