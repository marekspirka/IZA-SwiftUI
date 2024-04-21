//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import Foundation
import SwiftData


@Model
class Expense {
    var title: String
    var subTitle: String
    var amount: CGFloat
    var date: Date
    var category: Category?
    var type: String
    
    init(title: String, subTitle: String, amount: Double, date: Date, type: String, category: Category? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
    }
    
    static func calculateTotalEarningsAndExpenses(allExpenses: [Expense]) -> (earnings: Double, expenses: Double) {
        var totalEarnings: Double = 0
        var totalExpenses: Double = 0
        
        for expense in allExpenses {
            if expense.type == "income" {
                totalEarnings += expense.amount
            } else {
                totalExpenses += expense.amount
            }
        }
        
        return (totalEarnings, totalExpenses)
    }
    
    @Transient
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "" // Set currency symbol to empty string to prevent duplication

        if let amountString = formatter.string(for: amount) {
            return "\(amountString) €"
        } else {
            return ""
        }
    }
}
