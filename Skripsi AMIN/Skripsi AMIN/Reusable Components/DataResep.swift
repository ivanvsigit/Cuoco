//
//  DataResep.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 04/01/22.
//

import Foundation
import UIKit

struct DataResep: Codable {
    let recipeTitle: String
    let recipeInfo: RecipeInfo
    let ingredients: [Ingredients]
    let steps: [Steps]
}

struct RecipeInfo: Codable {
    let time: String
    let servings: String
    let difficulty: String
}

struct Ingredients: Codable {
    let items: [Items]
}

struct Items: Codable {
    let qty: String
    let item: String
}

struct Steps: Codable {
    let num: Int
    let step: String
    let images: [String]
}
