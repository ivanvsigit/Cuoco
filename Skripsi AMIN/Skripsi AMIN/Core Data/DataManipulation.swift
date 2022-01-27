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
    
    //MARK: Save Detail to Core Data
    
    var model = [CoreDetail]()
    
    //MARK: Create Item
    func createItem(title: String, thumb: String, key: String, saved: Bool){
        
        for data in model {
            if data.key == key {
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
            try context.save()
            getItem()
        } catch let error {
            print(error)
        }
    }
    
    //MARK: Get All Item
    func getItem(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SimpanResepDetail")
        
        do{
            let result = try context.fetch(fetchRequest)
//            as! [NSManagedObject]
//            result.forEach
            print(result)
            for data in result as! [NSManagedObject] {
//                if data.value(forKey: "key")
                    model.append(CoreDetail(image: data.value(forKey: "thumb") as? String, label: data.value(forKey: "title") as? String, key: data.value(forKey: "key") as! String, saved: data.value(forKey: "saved") as! Bool))
            }
        } catch let error{
            print(error)
        }
        
        print(model)
        
    }
    
    //MARK: Update Item
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
                print(managedObject)
                try context.save()
            }
            
            getItem()
        } catch let error{
            print(error)
        }
        
//        print(model)
        
    }
}
