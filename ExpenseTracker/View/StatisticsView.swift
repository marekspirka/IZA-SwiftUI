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
        NavigationStack {
            VStack {
                ScrollView {
                    MonthlyView(title: "Monthly Income", stats: monthlyIncomeStats, color: .green)
                    MonthlyView(title: "Monthly Expense", stats: monthlyExpenseStats, color: .red)
                    YearlyView(title: "Yearly Income", stats: yearlyIncomeStats, color: .green)
                    YearlyView(title: "Yearly Expense", stats: yearlyExpenseStats, color: .red)
                }
                .padding()
            }
            .navigationTitle("Statistics")
        }
    }
}

struct MonthlyView: View {
    let title: String
    let stats: [(String, Double)]
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .bold()
                .padding()
                .foregroundColor(color)
            Chart {
                ForEach(stats.indices, id: \.self) { index in
                    BarMark(x: .value("Month", stats[index].0),
                            y: .value(title, stats[index].1)
                    )
                    .cornerRadius(20)
                    .foregroundStyle(by: .value("Month", stats[index].0))
                }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding(20)
            .chartLegend(.hidden)
        }
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
        .padding()
    }
}

struct YearlyView: View {
    let title: String
    let stats: [(Int, Double)]
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .bold()
                .padding()
                .foregroundColor(color)
            Chart {
                ForEach(stats.indices, id: \.self) { index in
                    BarMark(x: .value("Year", "\(stats[index].0)"),
                            y: .value(title, stats[index].1)
                    )
                    .cornerRadius(20)
                    .foregroundStyle(by: .value("Year", "\(stats[index].0)"))
                }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding(20)
            .chartLegend(.hidden)
        }
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    StatisticsView()
}
