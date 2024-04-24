//
//  AccountView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) private var allExpenses: [Expense]
    
    var body: some View {
        VStack {
            CreditCardView(totalEarnings: totalEarnings, totalExpenses: totalExpenses)
                .padding()
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
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
            Text("My account")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 40)
                .padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 350, height: 200)
                .overlay(
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .center) {
                            Spacer()
                            VStack(alignment: .center) {
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
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Income:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(String(format: "%.2f", totalEarnings))€")
                                    .foregroundColor(.white)
                            }.padding()
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Expenses:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(String(format: "%.2f", totalExpenses))€")
                                    .foregroundColor(.white)
                            }.padding([.trailing], 20)
                        }
                    }
                    .padding()
                )
                .padding()
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    AccountView()
}
