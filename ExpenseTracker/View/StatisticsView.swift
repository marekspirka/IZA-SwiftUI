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
            List {
                VStack(alignment: .leading){
                    Text("Monthly Income:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    MonthlyView(stats: monthlyIncomeStats, color: .green)
                    Text("Monthly Expense:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    MonthlyView(stats: monthlyExpenseStats, color: .red)
                    Text("Yearly Income:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    YearlyView(stats: yearlyIncomeStats, color: .green)
                    Text("Yearly Expense:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    YearlyView(stats: yearlyExpenseStats, color: .red)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Statistics")
        }
    }
}

struct MonthlyView: View {
    let stats: [(String, Double)]
    let color: Color
    
    var body: some View {
        VStack {
            Chart {
                ForEach(stats.indices, id: \.self) { index in
                    BarMark(x: .value("Month", stats[index].0),
                            y: .value("Transfer", stats[index].1)
                    )
                    .cornerRadius(20)
                    .foregroundStyle(by: .value("Month", stats[index].0))
                }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding(20)
            .chartLegend(.hidden)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

struct YearlyView: View {
    let stats: [(Int, Double)]
    let color: Color
    
    var body: some View {
        VStack {
            Chart {
                ForEach(stats.indices, id: \.self) { index in
                    BarMark(x: .value("Year", "\(stats[index].0)"),
                            y: .value("Transfer", stats[index].1)
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
    }
}

#Preview {
    StatisticsView()
}
