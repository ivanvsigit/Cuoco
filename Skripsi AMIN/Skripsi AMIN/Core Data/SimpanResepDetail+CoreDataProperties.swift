//
//  SimpanResepDetail+CoreDataProperties.swift
//  Cuoco
//
//  Created by Ivan Valentino Sigit on 24/01/22.
//
//

import Foundation
import CoreData


extension SimpanResepDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SimpanResepDetail> {
        return NSFetchRequest<SimpanResepDetail>(entityName: "SimpanResepDetail")
    }

    @NSManaged public var title: String?
    @NSManaged public var saved: Bool
    @NSManaged public var key: String?
    @NSManaged public var thumb: String?

}

extension SimpanResepDetail : Identifiable {

}
