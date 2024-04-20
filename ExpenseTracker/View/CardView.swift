//
//  CardView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI

struct CardView: View {
    @Bindable var expesne: Expense
    var displayTag: Bool = true
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(expesne.title)
                
                Text(expesne.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if let catName = expesne.category?.catName, displayTag{
                    Text(catName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.red.gradient, in: .capsule)
                        
                }
            }
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            Text(expesne.currencyString)
                .font(.title3.bold())
        }
    }
}

