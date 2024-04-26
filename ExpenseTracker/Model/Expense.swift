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
        formatter.currencySymbol = ""

        if let amountString = formatter.string(for: amount) {
            return "\(amountString) €"
        } else {
            return ""
        }
    }
    
}

extension Array where Element == Expense {
    func monthlyAndYearlyStats() -> (monthlyIncome: [(month: String, income: Double)], monthlyExpenses: [(month: String, expenses: Double)], yearlyIncome: [(year: Int, income: Double)], yearlyExpenses: [(year: Int, expenses: Double)]) {
        var monthlyIncomeStats = [(month: String, income: Double)]()
        var monthlyExpenseStats = [(month: String, expenses: Double)]()
        var yearlyIncomeStats = [(year: Int, income: Double)]()
        var yearlyExpenseStats = [(year: Int, expenses: Double)]()
        
        // Dictionary to hold monthly and yearly totals
        var monthlyTotals = [String: (income: Double, expenses: Double)]()
        var yearlyTotals = [Int: (income: Double, expenses: Double)]()
        
        // Get current calendar
        let calendar = Calendar.current
        
        // Calculate totals
        for expense in self {
            let month = calendar.component(.month, from: expense.date)
            let year = calendar.component(.year, from: expense.date)
            let monthKey = "\(year)-\(month)"
            
            if expense.type == "income" {
                monthlyTotals[monthKey, default: (0, 0)].income += expense.amount
                yearlyTotals[year, default: (0, 0)].income += expense.amount
            } else {
                monthlyTotals[monthKey, default: (0, 0)].expenses += expense.amount
                yearlyTotals[year, default: (0, 0)].expenses += expense.amount
            }
        }
        
        // Convert totals to array format
        for (key, value) in monthlyTotals {
            let components = key.split(separator: "-")
            let month = String(components[1])
            let monthName = DateFormatter().monthSymbols[Int(month)! - 1]
            monthlyIncomeStats.append((month: monthName, income: value.income))
            monthlyExpenseStats.append((month: monthName, expenses: value.expenses))
        }
        
        for (key, value) in yearlyTotals {
            yearlyIncomeStats.append((year: key, income: value.income))
            yearlyExpenseStats.append((year: key, expenses: value.expenses))
        }
        
        // Sort by month/year
        monthlyIncomeStats.sort { $0.month < $1.month }
        monthlyExpenseStats.sort { $0.month < $1.month }
        yearlyIncomeStats.sort { $0.year < $1.year }
        yearlyExpenseStats.sort { $0.year < $1.year }
        
        return (monthlyIncome: monthlyIncomeStats, monthlyExpenses: monthlyExpenseStats, yearlyIncome: yearlyIncomeStats, yearlyExpenses: yearlyExpenseStats)
    }
}
