//
//  CapturedPokemon+CoreDataProperties.swift
//  pokedex
//
//  Created by Yung Kim on 7/25/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CapturedPokemon {

    @NSManaged var cp: NSNumber?
    @NSManaged var index: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var long: NSNumber?
    @NSManaged var name: String?
    @NSManaged var createdAt: NSDate?

}
