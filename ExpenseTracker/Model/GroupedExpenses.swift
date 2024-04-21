//
//  GroupedExpenses.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData


struct GroupedExpenses: Identifiable{
    var id: UUID = .init()
    var date: Date
    var expenses: [Expense]
    
    var groupTitle: String{
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date){
            return "Today"
        }else if calendar.isDateInYesterday(date){
            return "Yesterday"
        }else{
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
