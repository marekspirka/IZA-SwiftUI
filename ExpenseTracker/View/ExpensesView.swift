//
//  ExpensesView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Binding var currentTable: String

    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) private var allExpenses: [Expense]

    // Create an instance of ExpenseViewModel
    @StateObject private var viewModel = ExpenseViewModel()
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            VStack {
                totalEarningsAndExpensesView
                contentView
            }
            .navigationTitle("Expenses")
            .overlay {
                if allExpenses.isEmpty || viewModel.groupedExpenses.isEmpty { // Access groupedExpenses through viewModel
                    ContentUnavailableView {
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    viewModel.addExpenseButton
                }
            }
            .onChange(of: allExpenses, initial: true) { oldValue, newValue in
                if newValue.count > oldValue.count || viewModel.groupedExpenses.isEmpty || currentTable == "Categories" { // Access groupedExpenses through viewModel
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
        .environmentObject(viewModel) // Inject viewModel as environment object
    }

    private var totalEarningsAndExpensesView: some View {
        let (totalEarnings, totalExpenses) = Expense.calculateTotalEarningsAndExpenses(allExpenses: allExpenses)

        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Earnings")
                    .font(.headline)
                Text("\(totalEarnings) €")
            }
            .padding()

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text("Total Expenses")
                    .font(.headline)
                Text("\(totalExpenses) €")
                Text("\(totalExpenses-totalEarnings) €")
            }
            .padding()
        }
    }

    private var contentView: some View {
        List {
            ForEach(viewModel.groupedExpenses.indices, id: \.self) { index in // Access groupedExpenses through viewModel
                let group = viewModel.groupedExpenses[index] // Access groupedExpenses through viewModel
                let expensesOfTypeExpense = group.expenses.filter { $0.type == "expense" }
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

    private func expenseCard(_ expense: Expense) -> some View {
        ZStack {
            Button(action: {
                viewModel.editExpense(for: expense)
            }) {
                Color.clear // Invisible button to capture taps for editing
            }
            CardView(expense: expense)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        viewModel.deleteExpense(expense)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
        }
    }
}
