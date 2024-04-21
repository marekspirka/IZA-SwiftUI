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
    
    var isAddButtonDisabled: Bool {
        return title.isEmpty || subTitle.isEmpty || amount.isZero
    }
    
    var isEditing: Bool {
        return editExpense != nil
    }
    
    private var saveButtonTitle: String {
        return isEditing ? "Save" : "Add"
    }
  
    init(expense: Expense? = nil) {
        _editExpense = State(initialValue: expense)
        
        if let expense = expense {
            print("Som editovací")
            _title = State(initialValue: expense.title)
            _subTitle = State(initialValue: expense.subTitle)
            _date = State(initialValue: expense.date)
            _amount = State(initialValue: expense.amount)
            _category = State(initialValue: expense.category)
        } else {
            print("som novu vytvárací")
            _title = State(initialValue: "")
            _subTitle = State(initialValue: "")
            _date = State(initialValue: Date())
            _amount = State(initialValue: 0)
            _category = State(initialValue: nil)
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
            .navigationTitle(isEditing ? "Edit Expense" : "Add Expense")
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(saveButtonTitle) {
                        saveExpense()
                    }
                    .disabled(isAddButtonDisabled)
                }
            }
        }
    }
    
    func saveExpense() {
        if isEditing {
            guard let editExpense = editExpense else { return }
            editExpense.title = title
            editExpense.subTitle = subTitle
            editExpense.date = date
            editExpense.amount = amount
            editExpense.category = category
        } else {
            let expense = Expense(title: title, subTitle: subTitle, amount: amount, date: date, category: category)
            context.insert(expense)
        }
        
        dismiss()
    }
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
