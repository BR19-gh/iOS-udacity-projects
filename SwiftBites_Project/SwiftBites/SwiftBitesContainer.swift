//
//  SwiftBitesContainer.swift
//  SwiftBites
//
//  Created by Ibrahim Alkhowaiter on 20/10/2024.
//
import Foundation
import SwiftData

class SwiftBitesContainer {
    static func create() -> ModelContainer {
        // Define the schema with all your models
        let schema = Schema([Category.self, Ingredient.self, Recipe.self, RecipeIngredient.self])
        
        // Optional configuration for the model container
        let configuration = ModelConfiguration()
        
        // Create and return the ModelContainer with the defined schema
        return try! ModelContainer(for: schema, configurations: configuration)
    }
}
