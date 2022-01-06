//
//  ModelResep.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 04/01/22.
//

import Foundation

struct ModelResep {
    let recipeTitle: String
    let time: String
    let servings: String
    let difficulty: String
    let ingredients: [Ingredients]
    let steps: [Steps]
}

