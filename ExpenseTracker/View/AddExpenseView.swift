//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category?
    
    @Query(animation: .snappy) private var allCategories: [Category]
    
    
    var body: some View {
        NavigationStack{
            List{
                Section("Title"){
                    TextField("Name of Expense", text: $title)
                }
                
                Section("Desxription"){
                    TextField("Write here description", text: $subTitle)
                }
                
                Section("Price"){
                    HStack(spacing: 4){
                        Text("€")
                            .fontWeight(.semibold)
                        
                        TextField("0.0", value: $amount, formatter: formatter)
                            .keyboardType(.numberPad)
                    }
                }
                    
                    if !allCategories.isEmpty{
                        HStack{
                            Text("Category")
                            
                            Spacer()
                            
                            Menu {
                                ForEach(allCategories){
                                    category in Button(category.catName){
                                        self.category = category
                                    }
                                }
                                
                                Button("None"){
                                    category = nil
                                }
                                
                            }label: {
                                if let catName = category?.catName{
                                    Text(catName)
                                }else  {
                                    Text("None")
                                }
                            }
                        }
                    }
                    
                Section("Date"){
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                    
                    
            }
            .navigationTitle("Add Expense")
            .interactiveDismissDisabled()
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add",action: addExpense)
                        .disabled(isAddButtonDisabled)
                }
            }
        }
    }
    
    var isAddButtonDisabled: Bool{
        return title.isEmpty || subTitle.isEmpty || amount.isZero
    }
    
    func addExpense(){
        let expense = Expense(title: title, subTitle: subTitle, amount: amount, date: date, category: category)
        context.insert(expense)
        
        dismiss()
    }
    
    
    var formatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
