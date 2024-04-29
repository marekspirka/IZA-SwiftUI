//
//  AccountView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData


struct AccountView: View {
    @Binding var currentTable: String
    @StateObject private var viewModel = TransferViewModel()
    
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) private var allExpenses: [Expense]
    
    private var totalEarnings: Double {
        let (totalEarnings, _) = Expense.calculateTotalEarningsAndExpenses(allExpenses: allExpenses)
        return totalEarnings
    }
    
    private var totalExpenses: Double {
        let (_, totalExpenses) = Expense.calculateTotalEarningsAndExpenses(allExpenses: allExpenses)
        return totalExpenses
    }
    
    
    var body: some View {
        NavigationStack {
                List{
                    CreditCardView(totalEarnings: totalEarnings, totalExpenses: totalExpenses)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    Text("Last 3 days transfers:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    TransfersView(groupedExpenses: viewModel.groupedExpenses)
            }
            .onChange(of: allExpenses, initial: true) { oldValue, newValue in
                if newValue.count > oldValue.count || viewModel.groupedExpenses.isEmpty || currentTable == "Categories" {
                    Task {
                            await viewModel.groupExpenses(newValue)
                    }
                }
            }
        }
        .environmentObject(viewModel)
    }
}

struct TransfersView: View {
    var groupedExpenses: [GroupedExpenses]
    
    var body: some View {
        ForEach(groupedExpenses.prefix(3)) { groupedExpense in
            Section(header: Text(groupedExpense.groupTitle)) {
                ForEach(groupedExpense.expenses.prefix(3)) { expense in
                    CardView(expense: expense)
                        .cornerRadius(10.0)
                }
            }
        }
    }
}
