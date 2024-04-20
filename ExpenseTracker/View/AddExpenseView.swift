//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var editExpense: Expense?
    
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
    
    @Query(animation: .snappy) private var allCategories: [Category]
    
    init(expense: Expense? = nil) {
        editExpense = expense

        // If editing, pre-fill fields with expense data
        if let expense = expense {
            print("Received expense data for editing: \(expense)")
            _title = State(initialValue: expense.title)
            _subTitle = State(initialValue: expense.subTitle)
            _date = State(initialValue: expense.date)
            _amount = State(initialValue: expense.amount)
            _category = State(initialValue: expense.category)
        } else {
            print("No expense data received. Adding new expense.")
        }
    }

    
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("Name of Expense", text: $title)
                }
                
                Section("Description") {
                    TextField("Write here description", text: $subTitle)
                }
                
                Section("Price") {
                    HStack(spacing: 4) {
                        TextField("0.0", value: $amount, formatter: formatter)
                            .keyboardType(.numberPad)
                        Text("€").fontWeight(.semibold)
                    }
                }
                
                if !allCategories.isEmpty {
                    HStack {
                        Text("Category")
                        Spacer()
                        Menu {
                            ForEach(allCategories) { category in
                                Button(category.catName) {
                                    self.category = category
                                }
                            }
                            Button("None") {
                                category = nil
                            }
                        } label: {
                            if let catName = category?.catName {
                                Text(catName)
                            } else {
                                Text("None")
                            }
                        }
                    }
                }
                
                Section("Date") {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
            }
            .navigationTitle(editExpense == nil ? "Add Expense" : "Edit Expense")
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(editExpense == nil ? "Add" : "Save") {
                        editExpense == nil ? addExpense() : saveExpense()
                    }
                    .disabled(isAddButtonDisabled)
                }
            }
            
        }
        .onAppear {
            // If editing, populate fields with expense data
            if let expense = editExpense {
                title = expense.title
                subTitle = expense.subTitle
                date = expense.date
                amount = expense.amount
                category = expense.category
            }
        }
    }
    
    var isAddButtonDisabled: Bool {
        return title.isEmpty || subTitle.isEmpty || amount.isZero
    }
    
    func addExpense() {
        let expense = Expense(title: title, subTitle: subTitle, amount: amount, date: date, category: category)
        context.insert(expense)
        dismiss()
    }
    
    func saveExpense() {
        guard let editExpense = editExpense else { return }
        editExpense.title = title
        editExpense.subTitle = subTitle
        editExpense.date = date
        editExpense.amount = amount
        editExpense.category = category
        dismiss()
    }
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
