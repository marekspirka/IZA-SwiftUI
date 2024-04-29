//
//  CreditCardView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 28/04/2024.
//

import SwiftUI

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
