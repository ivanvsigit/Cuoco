//
//  SectionModel.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 04/01/22.
//

import Foundation
import UIKit

struct SectionModel {
    let title: String
    let content: [Content]
}

struct Content {
    let image: UIImage
    let label: String
    let detailKey: String
}

struct CoreModel {
    let detail: [CoreDetail]
}

struct CoreDetail {
    let image: String?
    let label: String?
    let key: String
    let saved: Bool
}

