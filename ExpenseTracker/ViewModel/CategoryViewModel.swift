//
//  CategoryViewModel.swift
//  ExpenseTracker
//
//  Created by Marek Špirka on 28/04/2024.
//

import SwiftUI
import SwiftData

class CategoryViewModel: ObservableObject {
    @Published var allCategories: [Category] = []
    @Published var addCategory: Bool = false
    @Published var catName: String = ""
    @Published var deleteCat: Bool = false
    @Published var requestedCategory: Category?

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func toggleAddCategory() {
        addCategory.toggle()
    }

    func toggleDeleteCategory(category: Category) {
        deleteCat.toggle()
        requestedCategory = category
    }

    func addNewCategory() {
        let category = Category(catName: catName)
        context.insert(category)
        catName = ""
        addCategory = false
    }

    func deleteCategory() {
        if let requestedCategory = requestedCategory {
            // Delete all expenses associated with the requested category
            if let expenses = requestedCategory.expenses {
                for expense in expenses {
                    context.delete(expense)
                }
            }
            // Delete the category itself
            context.delete(requestedCategory)        }
    }
}
