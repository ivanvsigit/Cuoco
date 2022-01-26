//
//  dataManipulation.swift
//  Cuoco
//
//  Created by Ivan Valentino Sigit on 25/01/22.
//

import Foundation
import UIKit
import CoreData

class DataManipulation {
    
    static var shared = DataManipulation()
    
    //MARK: Sava Detail to Core Data
    
    var model = [CoreDetail]()
    
    func createItem(title: String, thumb: String, key: String, saved: Bool){
        for data in model{
            if data.key == key{
                return
            }
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "SimpanResepDetail", in: context)!
        
        let insert = NSManagedObject(entity: userEntity, insertInto: context)
        
        insert.setValue(title, forKey: "title")
        insert.setValue(thumb, forKey: "thumb")
        insert.setValue(key, forKey: "key")
        insert.setValue(saved, forKey: "saved")
        
        do{
            getItem()
            
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func getItem(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SimpanResepDetail")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { data in
                model.append(CoreDetail(image: data.value(forKey: "thumb") as? String, label: data.value(forKey: "title") as? String, key: data.value(forKey: "key") as! String, saved: data.value(forKey: "saved") as! Bool))
            }
        } catch let error{
            print(error)
        }
        
        print(model)
        
    }
    
    func updateItem(key: String, value: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SimpanResepDetail")
        
        fetchRequest.predicate = NSPredicate(format: "key = %@", key)
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            if result.count != 0{
                let managedObject = result[0]
                managedObject.setValue(value, forKey: "saved")
            }
            try context.save()
            getItem()
        } catch let error{
            print(error)
        }
        
        print(model)
        
    }
    
//    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var models = [SimpanResepDetail]()
    
//    func getAllItems(){
//        do{
//            models = try context.fetch(SimpanResepDetail.fetchRequest())
//            DispatchQueue.main.async {
//                print("ambil data")
//            }
//        } catch {
//
//        }
//    }
    
//    func createItem(){
//        guard let detail = detailData else{
//            return
//        }
        
//        guard let image = detail.thumb else{
//            return
//        }
        
//        let newItem = SimpanResepDetail(context: context)
//        newItem.title = detail.title
//        newItem.thumb = image
//        newItem.key = resepKey
//        newItem.saved = false
//
//        do{
//            try context.save()
//            getAllItems()
//            print("berhasil")
//            print(models)
//        } catch{
//
//        }
//    }
    
}
