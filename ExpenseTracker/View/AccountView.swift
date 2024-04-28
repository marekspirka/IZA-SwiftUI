//
//  AccountView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData


struct AccountView: View {
    @Binding var currentTable: String
    @StateObject private var viewModel = TransferViewModel()
    
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) private var allExpenses: [Expense]
    
    private var totalEarnings: Double {
        let (totalEarnings, _) = Expense.calculateTotalEarningsAndExpenses(allExpenses: allExpenses)
        return totalEarnings
    }
    
    private var totalExpenses: Double {
        let (_, totalExpenses) = Expense.calculateTotalEarningsAndExpenses(allExpenses: allExpenses)
        return totalExpenses
    }
    
    
    var body: some View {
        NavigationStack {
                List{
                    CreditCardView(totalEarnings: totalEarnings, totalExpenses: totalExpenses)
                        .padding(.top, 20)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    Text("Last 3 days transfers:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    TransfersView(groupedExpenses: viewModel.groupedExpenses)
            }
            .onChange(of: allExpenses, initial: true) { oldValue, newValue in
                if newValue.count > oldValue.count || viewModel.groupedExpenses.isEmpty || currentTable == "Categories" {
                    Task {
                            await viewModel.groupExpenses(newValue)
                    }
                }
            }
        }
        .environmentObject(viewModel)
    }
}

struct TransfersView: View {
    var groupedExpenses: [GroupedExpenses]
    
    var body: some View {
        ForEach(groupedExpenses.prefix(3)) { groupedExpense in
            Section(header: Text(groupedExpense.groupTitle)) {
                ForEach(groupedExpense.expenses.prefix(3)) { expense in
                    CardView(expense: expense)
                        .cornerRadius(10.0)
                }
            }
        }
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
