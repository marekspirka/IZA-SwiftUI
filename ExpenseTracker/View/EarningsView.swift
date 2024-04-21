//
//  EarningsView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct EarningsView: View {
    @Binding var currentTable: String 
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) private var allExpenses: [Expense]
    
    @StateObject private var viewModel = ExpenseViewModel()
    @Environment(\.modelContext) private var context
    @State private var isAddingNew: Bool = false
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Incomes")
                .overlay {
                    if allExpenses.isEmpty || viewModel.groupedExpenses.isEmpty {
                        ContentUnavailableView {
                            Label("No Incomes", systemImage: "pencil.slash")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        viewModel.addExpenseButton
                    }
                }
                .onChange(of: allExpenses, initial: true) { oldValue, newValue in
                    if newValue.count > oldValue.count || viewModel.groupedExpenses.isEmpty || currentTable == "Categories" {
                        Task {
                                await viewModel.groupExpenses(newValue)
                        }
                    }
                }
                .background(
                    EmptyView()
                        .navigationDestination(
                            isPresented: viewModel.isPushedBinding,
                            destination: {
                                AddExpenseView(expense: viewModel.isAddingNew ? nil : viewModel.selectedExpense)
                                    .interactiveDismissDisabled()
                            }
                        )
                )
        }
    }
    
    private var contentView: some View {
        List {
            ForEach(viewModel.groupedExpenses.indices, id: \.self) { index in
                let group = viewModel.groupedExpenses[index]
                let expensesOfTypeExpense = group.expenses.filter { $0.type == "income" }
                if !expensesOfTypeExpense.isEmpty {
                    Section(header: Text(group.groupTitle)) {
                        ForEach(expensesOfTypeExpense) { expense in
                            expenseCard(expense)
                        }
                    }
                }
            }
        }
    }
    func deleteExpense(_ expense: Expense) {
        context.delete(expense)

        viewModel.updateAfterDeleted(expense)
    }

    private func expenseCard(_ expense: Expense) -> some View {
        ZStack {
            Button(action: {
                viewModel.editExpense(for: expense)
            }) {
                Color.clear
            }
            CardView(expense: expense)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        deleteExpense(expense)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
        }
    }
}

