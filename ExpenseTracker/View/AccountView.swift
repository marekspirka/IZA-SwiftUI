//
//  AccountView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData
import Charts

struct AccountView: View {
    
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) private var allExpenses: [Expense]
    
    var body: some View {
        ScrollView {
            VStack{
                CreditCardView(totalEarnings: totalEarnings, totalExpenses: totalExpenses)
                    .padding()
                Spacer(minLength: 50)
                ScrollView{
                    VStack {
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
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(20)
                    .padding()
                }
                .padding()
            }
        }
    }
    
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
    
    private var totalEarnings: Double {
        let (totalEarnings, _) = Expense.calculateTotalEarningsAndExpenses(allExpenses: allExpenses)
        return totalEarnings
    }
    
    private var totalExpenses: Double {
        let (_, totalExpenses) = Expense.calculateTotalEarningsAndExpenses(allExpenses: allExpenses)
        return totalExpenses
    }
}

struct CreditCardView: View {
    let totalEarnings: Double
    let totalExpenses: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("CreditLeftColor"),
                            Color("CreditRightColor")
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 350, height: 230)
                .overlay(cardContent)
                .padding()
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
            
            Spacer()
        }
        .navigationTitle("Your Account")
    }

    private var cardContent: some View {
        VStack(spacing: 30) {
            Text("Your account")
                .bold()
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom, 0)
            totalAmountView
                .padding(.top, 0)
            HStack {
                incomeView
                Spacer()
                expenseView
            }
        }
        .padding()
    }
    
    private var totalAmountView: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("Total:")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("\(String(format: "%.2f", totalEarnings - totalExpenses))€")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
            }
        }
    }
    
    private var incomeView: some View {
        HStack{
            Image(systemName: "arrow.up")
                .foregroundStyle(.green)
                .bold()
                .padding(12)
                .background {
                Circle()
                        .fill(.green.opacity(0.3))
                }
            VStack(alignment: .leading) {
                Text("Income:")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(String(format: "%.2f", totalEarnings))€")
                    .foregroundColor(.white)
            }
        }
    }
    
    private var expenseView: some View {
        HStack{
            Image(systemName: "arrow.down")
                .foregroundStyle(.red)
                .bold()
                .padding(12)
                .background {
                Circle()
                        .fill(.red.opacity(0.3))
                }
            VStack(alignment: .leading) {
                Text("Expense:")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(String(format: "%.2f", totalExpenses))€")
                    .foregroundColor(.white)
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    AccountView()
}
