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
            content
                .navigationTitle("Categories")
                .overlay{
                    if allCategories.isEmpty {
                        ContentUnavailableView{
                            Label("No Categories", systemImage: "tray.fill")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        addButton
                    }
                }
                .sheet(isPresented: $addCategory) {
                    addCategorySheet
                }
                .alert(isPresented: $deleteCat, content: {
                    deleteCategoryAlert
                })
        }
    }
    
    private var content: some View {
        List {
            ForEach(allCategories.sorted(by: { ($0.expenses?.count ?? 0) > ($1.expenses?.count ?? 0) })) { category in
                disclosureGroup(for: category)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            deleteCat.toggle()
                            requestedCategory = category
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
            }
        }
    }
    
    private func disclosureGroup(for category: Category) -> some View {
        DisclosureGroup {
            if let expenses = category.expenses, !expenses.isEmpty {
                ForEach(expenses) { expense in
                    CardView(expense: expense, displayTag: false)
                }
            } else {
                ContentUnavailableView {
                    Label("No expenses", systemImage: "tray.fill")
                }
            }
        } label: {
            Text(category.catName)
        }
    }
    
    private var addButton: some View {
        Button {
            addCategory.toggle()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title3)
        }
    }
    
    private var addCategorySheet: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("General", text: $catName)
                }
            }
            .navigationTitle("Category name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        addCategory = false
                    }
                    .tint(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let category = Category(catName: catName)
                        context.insert(category)
                        catName = ""
                        addCategory = false
                    }
                    .disabled(catName.isEmpty)
                }
            }
        }
        .presentationDetents([.height(250)])
        .presentationCornerRadius(20)
        .interactiveDismissDisabled()
    }
    
    private var deleteCategoryAlert: Alert {
        Alert(
            title: Text("Delete Category"),
            message: Text("If you delete a category, all associated expenses will be deleted too"),
            primaryButton: .destructive(Text("Delete")) {
                if let requestedCategory = requestedCategory {
                    // Delete all expenses associated with the requested category
                    if let expenses = requestedCategory.expenses {
                        for expense in expenses {
                            context.delete(expense)
                        }
                    }
                    // Delete the category itself
                    context.delete(requestedCategory)
                    self.requestedCategory = nil
                }
            },
            secondaryButton: .cancel(Text("Cancel")) {
                requestedCategory = nil
            }
        )
    }
}
