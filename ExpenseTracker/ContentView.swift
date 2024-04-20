//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentTab: String = "Expenses"
    
    var body: some View{
        TabView(selection: $currentTab){
            
            ExpensesView(currentTable: $currentTab)
                .tag("Expenses")
                .tabItem{
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            CategoryView()
                .tag("Categories")
                .tabItem{
                    Image(systemName: "creditcard.fill")
                    Text("Categories")
                }
        }
    }
}


#Preview {
    ContentView()
}
