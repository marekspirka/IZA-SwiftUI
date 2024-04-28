//
//  StatisticsView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 28/04/2024.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) private var allExpenses: [Expense]
    
    private var monthlyIncomeStats: [(month: String, income: Double)] {
            return allExpenses.monthlyAndYearlyStats().monthlyIncome
        }
        
    private var monthlyExpenseStats: [(month: String, expenses: Double)] {
            return allExpenses.monthlyAndYearlyStats().monthlyExpenses
        }
    
    private var yearlyIncomeStats: [(year: Int, income: Double)] {
        return allExpenses.monthlyAndYearlyStats().yearlyIncome
    }
    
    private var yearlyExpenseStats: [(year: Int, expenses: Double)] {
        return allExpenses.monthlyAndYearlyStats().yearlyExpenses
    }
    

        var body: some View {
            ScrollView{
                MonthlyIncomeView
                MonthlyExpenseView
                YearlyIncomeView
                YearlyExpenseView
            }
            .padding()
        }
    
    private var MonthlyIncomeView: some View{
        VStack {
            Text("Monthly Income")
                .font(.title)
            Chart {
                ForEach(monthlyIncomeStats.indices, id: \.self) { index in
                    BarMark(x: .value("Month", monthlyIncomeStats[index].month),
                            y: .value("Income", monthlyIncomeStats[index].income)
                    )
                    .cornerRadius(20)
                    .foregroundStyle(by: .value("Month", monthlyIncomeStats[index].month))
                }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding(20)
            .chartLegend(.hidden)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        .padding()
    }
    
    private var MonthlyExpenseView: some View{
        VStack {
            Text("Monthly Expense")
                .font(.title)
            Chart {
                ForEach(monthlyExpenseStats.indices, id: \.self) { index in
                    BarMark(x: .value("Month", monthlyExpenseStats[index].month),
                            y: .value("Expense", monthlyExpenseStats[index].expenses)
                    )
                    .cornerRadius(20)
                    .foregroundStyle(by: .value("Month", monthlyExpenseStats[index].month))
                }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding(20)
            .chartLegend(.hidden)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        .padding()
    }
    
    private var YearlyIncomeView: some View{
        VStack {
            Text("Yearly Income")
                .font(.title)
            Chart {
                ForEach(yearlyIncomeStats.indices, id: \.self) { index in
                    BarMark(x: .value("Year", yearlyIncomeStats[index].year),
                            y: .value("Income", yearlyIncomeStats[index].income)
                    )
                    .cornerRadius(20)
                    .foregroundStyle(by: .value("Year", yearlyIncomeStats[index].year))
                }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding(20)
            .chartLegend(.hidden)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        .padding()
    }
    
    private var YearlyExpenseView: some View{
        VStack {
            Text("Yearly Expense")
                .font(.title)
            Chart {
                ForEach(yearlyExpenseStats.indices, id: \.self) { index in
                    BarMark(x: .value("Year", yearlyExpenseStats[index].year),
                            y: .value("Expense", yearlyExpenseStats[index].expenses)
                    )
                    .cornerRadius(20)
                    .foregroundStyle(by: .value("Year", yearlyExpenseStats[index].year))
                }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding(20)
            .chartLegend(.hidden)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    StatisticsView()
}
