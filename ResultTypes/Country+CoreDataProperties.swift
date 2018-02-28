//
//  Country+CoreDataProperties.swift
//  ResultTypes
//
//  Created by Mazharul Huq on 2/27/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var area: Int32
    @NSManaged public var capital: String?
    @NSManaged public var name: String?
    @NSManaged public var population: Int32

}
