//
//  TransferViewModel.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 21/04/2024.
//

import SwiftUI
import SwiftData

class ExpenseViewModel: ObservableObject {
    @Published var groupedExpenses: [GroupedExpenses] = []
    @Environment(\.modelContext) private var context
    @Published var isPushed: Bool = false
    @Published var selectedExpense: Expense?
    
    // New state variable to track the intention to add or edit
    @Published var isAddingNew: Bool = false

    func groupExpenses(_ expenses: [Expense]) async {
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { expense in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: expense.date)
                return dateComponents
            }

            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? Date()
                let date2 = calendar.date(from: $1.key) ?? Date()
                return calendar.compare(date1,  to: date2, toGranularity: .day) == .orderedDescending
            }

            await MainActor.run {
                self.groupedExpenses = sortedDict.compactMap { dict in
                    let date = Calendar.current.date(from: dict.key) ?? Date()
                    return GroupedExpenses(date: date, expenses: dict.value)
                }
            }
        }
    }
    var addExpenseButton: some View {
        Button {
            self.isPushed = true
            self.isAddingNew = true // Set the intention to add new expense
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title3)
        }
    }

    func editExpense(for expense: Expense) {
        selectedExpense = expense
        isPushed = true
        isAddingNew = false // Set the intention to edit existing expense
    }

    func deleteExpense(_ expense: Expense) {
        context.delete(expense)

        groupedExpenses.indices.forEach { index in // Access groupedExpenses through viewModel
            var group = groupedExpenses[index] // Access groupedExpenses through viewModel
            group.expenses.removeAll { $0.id == expense.id }

            if group.expenses.isEmpty {
                groupedExpenses.remove(at: index) // Access groupedExpenses through viewModel
            } else {
                groupedExpenses[index] = group // Access groupedExpenses through viewModel
            }
        }
    }
    
    // Define a binding property for isPushed
        var isPushedBinding: Binding<Bool> {
            Binding(
                get: { self.isPushed },
                set: { newValue in
                    self.isPushed = newValue
                }
            )
        }
}
