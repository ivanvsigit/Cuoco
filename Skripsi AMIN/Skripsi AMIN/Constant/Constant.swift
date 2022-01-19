//
//  Constant.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 09/01/22.
//

import Foundation
import UIKit

 // MARK: All property that can't be change
struct Constant{
    
    static var shared = Constant()
    
    let urlCategory = "https://masak-apa.tomorisakura.vercel.app/api/categorys/recipes/"
    let urlSearch = "https://masak-apa.tomorisakura.vercel.app/api/search/?q="
    let urlNewest = "https://masak-apa.tomorisakura.vercel.app/api/recipes"
    
    // MARK: Hold the API Resep Category Data
    var data = [DataContent]()
    
     // MARK: Hold the API Newest Resep Data
    var newest = [DataContent]()
    
    // MARK: Hold the API Search Data
    var search = [DataContent]()
    
    var searchKey = ""
    
    enum Key: CodingKey{
        case desert
        case hari_raya
        case tradisional
        case makan_malam
        case makan_siang
        case ayam
        case daging
        case sayuran
        case seafood
        case sarapan
    }
    
     // MARK: Get the API Key
    func getKey(key: Key) -> String{
        if key == Key.desert{
            return "resep-desert"
        }
        else if key == Key.hari_raya{
            return "masakan-hari-raya"
        }
        else if key == Key.tradisional{
            return "masakan-tradisional"
        }
        else if key == Key.makan_malam{
            return "makan-malam"
        }
        else if key == Key.makan_siang{
            return "makan-siang"
        }
        else if key == Key.ayam{
            return "resep-ayam"
        }
        else if key == Key.daging{
            return "resep-daging"
        }
        else if key == Key.sayuran{
            return "resep-sayuran"
        }
        else if key == Key.seafood{
            return "resep-seafood"
        }
        else if key == Key.sarapan{
            return "sarapan"
        }
        return ""
    }
    
    // MARK: Get Image From URL
   func getImage(urlKey: String)->Data{
       var dataFinal = Data()
       if let url  = URL(string: urlKey){
           do{
               let data = try Data(contentsOf: url)
               dataFinal = data
               return data
           }
           catch{
               print(error)
           }
       }
       return dataFinal
   }
}
