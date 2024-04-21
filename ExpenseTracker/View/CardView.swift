//
//  CardView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI

struct CardView: View {
    @Bindable var expense: Expense
    var displayTag: Bool = true
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(expense.title)
                
                Text(expense.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if let catName = expense.category?.catName, displayTag {
                    Text(catName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.red.gradient, in: .capsule)
                }
            }
            .lineLimit(1)
            
            Spacer(minLength: 8)
            
            Text(expense.currencyString)
                .font(.title3.bold())
            
            Text(expense.type == "income" ? "Income" : "Expense")
                    .font(.caption)
                    .foregroundColor(expense.type == "income" ? .green : .red)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(expense.type == "income" ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    )
        }
    }
}


