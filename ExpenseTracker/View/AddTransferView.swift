//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct AddTransferView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @ObservedObject private var viewModel: AddExpenseViewModel
    @Query(animation: .snappy) private var allCategories: [Category]
    
    var isAddButtonDisabled: Bool {
        return viewModel.title.isEmpty || viewModel.subTitle.isEmpty || viewModel.amount.isZero || viewModel.type.isEmpty
    }
    
    var isEditing: Bool {
        return viewModel.editExpense != nil
    }
    
    private var saveButtonTitle: String {
        return isEditing ? "Save" : "Add"
    }
  
    init(expense: Expense? = nil, context: ModelContext) {
        self.viewModel = AddExpenseViewModel(context: context, expense: expense)
    }

    var body: some View {
        HStack {
            List {
                Section("Title") {
                    TextField("Name of Expense", text: $viewModel.title)
                }
                               
                Section("Description") {
                    TextField("Write here description", text: $viewModel.subTitle)
                }
                               
                Section("Price") {
                    HStack(spacing: 4) {
                        TextField("0.0", value: $viewModel.amount, formatter: NumberFormatter())
                            .keyboardType(.decimalPad) // Use decimalPad for entering amount
                        Text("€").fontWeight(.semibold)
                    }
                }
                               
                Section("Type") {
                    Picker("Type", selection: $viewModel.type) {
                        Text("Expense").tag("expense")
                        Text("Income").tag("income")
                    }
                        .pickerStyle(SegmentedPickerStyle())
                }
                               
                if !allCategories.isEmpty {
                    Section("Category") {
                        Menu {
                            ForEach(allCategories) { category in
                                Button(category.catName) {
                                    viewModel.category = category
                                }
                            }
                            Button("None") {
                                viewModel.category = nil
                            }
                        } label: {
                            if let catName = viewModel.category?.catName {
                                Text(catName)
                            } else {
                                Text("None")
                            }
                        }
                    }
                }
                               
                Section("Date") {
                    DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Transfer" : "Add Transfer")
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(saveButtonTitle) {
                        viewModel.saveExpense()
                        dismiss()
                    }
                    .disabled(isAddButtonDisabled)
                }
            }
        }
    }