//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentTab: String = "Expense"
    
    var body: some View{
        TabView(selection: $currentTab){
            
            ExpensesView(currentTable: $currentTab)
                .tag("Expense")
                .tabItem{
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            CategoryView()
                .tag("Category")
                .tabItem{
                    Image(systemName: "creditcard.fill")
                    Text("Category")
                }
        }
    }
}


#Preview {
    ContentView()
}
