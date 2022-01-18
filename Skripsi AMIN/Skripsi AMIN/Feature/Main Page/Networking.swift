//
//  Networking.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 09/01/22.
//

import Foundation

struct API{
    
    static var shared = API()
    
    func fetchDataAPI(urlKey: String, completion: @escaping ()->()) {
         // MARK: Create a URL
        let url = URL(string: Constant.shared.urlCategory+urlKey)
        
         // MARK: URLSession bertujuan untuk mengelola sekelompok tugas yang berhubungan dengan network data transfer (buat ngebuka pintunya)
        let session = URLSession(configuration: .default)
        
         // MARK: Give the session a task
        let task = session.dataTask(with: url!) { data, resp, error in
            if error != nil{
                print(error!)
            }
            if let safe_data = data {
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(DataResep.self, from: safe_data)
//                    print(result)
                    for data in result.results {
                        Constant.shared.data.append(DataContent(title: data.title, thumb: data.thumb, key: data.key, times: data.times, serving: data.portion, dificulty: data.dificulty))
                    }
                    completion()
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func fetchSearchDataAPI(urlKey: String, completion: @escaping(()->())) {
        Constant.shared.search.removeAll()
        
         // MARK: Create a URL
        let url = URL(string: Constant.shared.urlSearch+urlKey)
        
         // MARK: URLSession bertujuan untuk mengelola sekelompok tugas yang berhubungan dengan network data transfer (buat ngebuka pintunya)
        let session = URLSession(configuration: .default)
        
         // MARK: Give the session a task
        let task = session.dataTask(with: url!) { data, resp, error in
            if error != nil{
                print(error!)
            }
            if let safe_data = data {
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(SearchResult.self, from: safe_data)
//                    print(result)
                    for data in result.results {
                        Constant.shared.search.append(DataContent(title: data.title, thumb: data.thumb, key: data.key, times: data.times, serving: data.serving, dificulty: data.difficulty))
                    }
                    completion()
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func fetchNewestResepDataAPI(completion: @escaping(()->())) {
         // MARK: Create a URL
        let url = URL(string: Constant.shared.urlNewest)
        
         // MARK: URLSession bertujuan untuk mengelola sekelompok tugas yang berhubungan dengan network data transfer (buat ngebuka pintunya)
        let session = URLSession(configuration: .default)
        
         // MARK: Give the session a task
        let task = session.dataTask(with: url!) { data, resp, error in
            if error != nil{
                print(error!)
            }
            if let safe_data = data {
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(DataResep.self, from: safe_data)
                    for data in result.results {
                        Constant.shared.newest.append(DataContent(title: data.title, thumb: data.thumb, key: data.key, times: data.times, serving: data.portion, dificulty: data.dificulty))
                    }
                    completion()
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func fetchSearchResultDataAPI(urlKey: String, completion: @escaping(()->())) {
        Constant.shared.search.removeAll()
        
         // MARK: Create a URL
        let url = URL(string: Constant.shared.urlSearch+urlKey)
        
         // MARK: URLSession bertujuan untuk mengelola sekelompok tugas yang berhubungan dengan network data transfer (buat ngebuka pintunya)
        let session = URLSession(configuration: .default)
        
         // MARK: Give the session a task
        let task = session.dataTask(with: url!) { data, resp, error in
            if error != nil{
                print(error!)
            }
            if let safe_data = data {
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(SearchResult.self, from: safe_data)
//                    print(result)
                    for data in result.results {
                        Constant.shared.search.append(DataContent(title: data.title, thumb: data.thumb, key: data.key, times: data.times, serving: data.serving, dificulty: data.difficulty))
                    }
                    completion()
                    Constant.shared.search.removeAll()
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }

}


