//
//  ExpensesView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Binding var currentTable: String
    
    @Query(sort: [
        SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) private var allExpenses: [Expense]
    
    @State private var groupedExpenses: [GroupedExpenses] = []
    @State private var addExpense: Bool = false
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack{
            List{
                ForEach($groupedExpenses){
                    $group in Section(group.groupTitle){
                        ForEach(group.expenses){
                            expense in CardView(expesne: expense)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                    Button{
                                        context.delete(expense)
                                        withAnimation{
                                            group.expenses.removeAll(where: {$0.id == expense.id})
                                            
                                            //if there is no expense, delete group
                                            if group.expenses.isEmpty{
                                                groupedExpenses.removeAll(where: {$0.id == group.id})
                                            }
                                        }
                                    }label: {
                                        Image(systemName: "trash")
                                    }.tint(.red)
                                }
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .overlay{
                if allExpenses.isEmpty || groupedExpenses.isEmpty{
                    ContentUnavailableView{
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        addExpense.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
        .onChange(of: allExpenses, initial: true){ oldValue, newValue in
            if newValue.count > oldValue.count || groupedExpenses.isEmpty || currentTable == "Categories" {
                GroupedExpenses(newValue)
            }
        }
        .sheet(isPresented: $addExpense){
            AddExpenseView()
                .interactiveDismissDisabled()
        }
    }
    func GroupedExpenses(_ expenses: [Expense]){
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { expense in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from:
                                                                        expense.date)
                return dateComponents
            }
            
            
            let sordedDict = groupedDict.sorted{
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1,  to: date2, toGranularity: .day) == .orderedDescending
                
                
            }
            await MainActor.run{
                groupedExpenses = sordedDict.compactMap({dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                })
            }
        }
    }
}

#Preview{
    ContentView()
}
