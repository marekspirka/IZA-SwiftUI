//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var currentTab: String = "My account"
    
    var body: some View{
        TabView(selection: $currentTab){
            
            AccountView(currentTable: $currentTab)
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
                .tag("Incomes")
                .tabItem{
                    Image(systemName: "arrow.up.forward.circle.fill")
                    Text("Incomes")
                }
            CategoryView()
                .tag("Categories")
                .tabItem {
                    Image(systemName: "text.justify")
                    Text("Categories")
                }
            StatisticsView()
                .tag("Statistics")
                .tabItem{
                    Image(systemName: "chart.bar.xaxis.ascending")
                    Text("Statistics")
                }
        }
    }
}
