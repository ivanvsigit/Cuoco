//
//  DataResep.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 04/01/22.
//

import Foundation
import UIKit

struct DataResep: Codable {
    let results: [ContentResep]
}

struct SearchResult: Codable {
    let results: [SearchModel]
}

struct ResepTerbaru: Codable {
    let results: [ContentResep]
}

struct DataDetail: Codable {
    let results: DetailResep
}

struct ContentResep: Codable {
    let title: String
    let thumb: String
    let key: String
    let times: String
    let portion: String
    let dificulty: String
}

struct DetailResep: Codable {
    let title: String
    let thumb: String?
    let servings: String
    let times: String
    let dificulty: String
    let author: DetailAuthor
    let desc: String
    let needItem: [DetailItem]
    let ingredient: [String]
    let step: [String]
}

struct DetailAuthor: Codable {
    let user: String
    let datePublished: String
}

struct DetailItem: Codable {
    let item_name: String
    let thumb_item: String
}

struct SearchModel: Codable {
    let title: String
    let thumb: String
    let key: String
    let times: String
    let serving: String
    let difficulty: String
}


 // MARK: API LAMA
//struct DataResep: Codable {
//    let recipeTitle: String
//    let recipeInfo: RecipeInfo
//    let ingredients: [Ingredients]
//    let steps: [Steps]
//}
//
//struct RecipeInfo: Codable {
//    let time: String
//    let servings: String
//    let difficulty: String
//}
//
//struct Ingredients: Codable {
//    let items: [Items]
//}
//
//struct Items: Codable {
//    let qty: String
//    let item: String
//}
//
//struct Steps: Codable {
//    let num: Int
//    let step: String
//    let images: [String]
//}
