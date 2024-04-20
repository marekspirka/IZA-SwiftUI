//
//  CategoryView.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 20/04/2024.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    @Query(animation: .snappy) private var allCategories: [Category]
    @Environment(\.modelContext) private var context
    
    
    @State private var addCategory: Bool = false
    @State private var catName: String = ""
    
    @State private var deleteCat: Bool = false
    @State private var requestedCategory: Category?
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(allCategories.sorted(by: {($0.expenses?.count ?? 0) > ($1.expenses?.count ?? 0)
                })){ category in
                    DisclosureGroup{
                        if let expenses = category.expenses, !expenses.isEmpty{
                            ForEach(expenses){
                                expense in CardView(expesne: expense, displayTag: false)
                            }
                            
                        }else {
                            ContentUnavailableView{
                                Label("No expenses", systemImage: "tray.fill")
                            }
                        }
                    }label: {
                        Text(category.catName)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false){
                        Button{
                            deleteCat.toggle()
                            requestedCategory = category
                        }label: {
                            Image(systemName: "trash")
                        }.tint(.red)
                    }
                }
                
            }
            .navigationTitle("Categories")
            .overlay{
                if allCategories.isEmpty{
                    ContentUnavailableView{
                        Label("No Categories", systemImage: "tray.fill")
                    }
                }
            }
            
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        addCategory.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $addCategory){
                catName = ""
            } content: {
                NavigationStack{
                    List{
                        Section("Title"){
                            TextField("General", text: $catName)
                        }
                    }
                    .navigationTitle("Category name")
                    .navigationBarTitleDisplayMode(.inline)
                    
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel"){
                                addCategory = false
                            }
                            .tint(.red)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add"){
                                let category = Category(catName: catName)
                                context.insert(category)
                                
                                catName = ""
                                addCategory = false
            
                            }
                            .disabled(catName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.height(180)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
            }
        }
        .alert("If you delete a category, all associateed expenses will be deleted too",isPresented: $deleteCat){
            Button(role: .destructive){
                if let requestedCategory{
                    context.delete(requestedCategory)
                    self.requestedCategory = nil
                }
            }label :{
                Text("Delete")
            }
            Button(role: .cancel){
                requestedCategory = nil
            }label: {
                Text("Cancel")
            }
        }
    }
}


