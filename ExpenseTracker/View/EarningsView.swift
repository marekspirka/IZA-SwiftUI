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
    
    @State private var groupedExpenses: [GroupedExpenses] = []
    @State private var isPushed: Bool = false
    @State private var selectedExpense: Expense?
    @Environment(\.modelContext) private var context
    
    // New state variable to track the intention to add or edit
    @State private var isAddingNew: Bool = false
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Incomes")
                .overlay {
                    if allExpenses.isEmpty || groupedExpenses.isEmpty {
                        ContentUnavailableView {
                            Label("No Incomes", systemImage: "tray.fill")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        addExpenseButton
                    }
                }
                .onChange(of: allExpenses, initial: true) { oldValue, newValue in
                    if newValue.count > oldValue.count || groupedExpenses.isEmpty || currentTable == "Categories" {
                        GroupedExpenses(newValue)
                    }
                }
                .background(
                    EmptyView()
                        .navigationDestination(
                            isPresented: $isPushed,
                            destination: {
                                AddExpenseView(expense: isAddingNew ? nil : selectedExpense)
                                    .interactiveDismissDisabled()
                            }
                        )
                )
        }
    }
    
    private var contentView: some View {
        List {
            ForEach(groupedExpenses.indices, id: \.self) { index in
                let group = groupedExpenses[index]
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

    private func expenseCard(_ expense: Expense) -> some View {
        ZStack {
            Button(action: {
                editExpense(for: expense)
            }) {
                Color.clear // Invisible button to capture taps for editing
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

    private var addExpenseButton: some View {
        Button {
            isPushed = true
            isAddingNew = true // Set the intention to add new expense
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title3)
        }
    }
    
    private func editExpense(for expense: Expense) {
        selectedExpense = expense
        isPushed = true
        isAddingNew = false // Set the intention to edit existing expense
    }

    
    private func deleteExpense(_ expense: Expense) {
        context.delete(expense)
        
        groupedExpenses.indices.forEach { index in
            var group = groupedExpenses[index]
            group.expenses.removeAll { $0.id == expense.id }
            
            if group.expenses.isEmpty {
                groupedExpenses.remove(at: index)
            } else {
                groupedExpenses[index] = group
            }
        }
    }

    
    private func GroupedExpenses(_ expenses: [Expense]) {
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { expense in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from:
                                                                            expense.date)
                return dateComponents
            }
            
            let sordedDict = groupedDict.sorted{
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                           
                return calendar.compare(date1,  to: date2, toGranularity: .day) == .orderedDescending
            }
            
            await MainActor.run{
                groupedExpenses = sordedDict.compactMap({dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                })
            }
        }
    }
}

