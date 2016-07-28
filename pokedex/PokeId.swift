//
//  PokeId.swift
//  pokedex
//
//  Created by Daniel Ra on 7/26/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import Foundation

class PokeId {
    var name: String?
    var weight: String?
    var height: String?
    var experience: String?
    init(dictionary: NSDictionary){
        name = dictionary.valueForKey("name") as? String
        weight = dictionary.valueForKey("weight") as? String
        height = dictionary.valueForKey("height") as? String
        experience = (dictionary.valueForKey("experience") as? String)
    }
}