//
//  AddTransferViewModel.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 28/04/2024.
//

import SwiftUI
import SwiftData

class AddExpenseViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var subTitle: String = ""
    @Published var date: Date = Date()
    @Published var amount: CGFloat = 0
    @Published var category: Category?
    @Published var type: String = ""
    
    @Published var editExpense: Expense?
    
    private let context: ModelContext
    
    init(context: ModelContext, expense: Expense? = nil) {
        self.context = context
        self.editExpense = expense
        
        if let expense = expense {
            self.title = expense.title
            self.subTitle = expense.subTitle
            self.date = expense.date
            self.amount = expense.amount
            self.category = expense.category
            self.type = expense.type
        }
    }
    
    func saveExpense() {
        if let editExpense = editExpense {
            editExpense.title = title
            editExpense.subTitle = subTitle
            editExpense.date = date
            editExpense.amount = amount
            editExpense.category = category
            editExpense.type = type
        } else {
            let expense = Expense(title: title, subTitle: subTitle, amount: amount, date: date, type: type, category: category)
            context.insert(expense)
        }
    }
}
