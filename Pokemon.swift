//
//  Pokemon.swift
//  pokedex
//
//  Created by Yung Kim on 7/21/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import Foundation
import CoreData


class Pokemon: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static func getAllPokemons(completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        // Specify the url that we will be sending the GET Request to
        let url = NSURL(string: "https://pokeapi.co/api/v2/pokemon/?limit=151")
        // Create an NSURLSession to handle the request tasks
        let session = NSURLSession.sharedSession()
        // Create a "data task" which will request some data from a URL and then run the completion handler that we are passing into the getAllPeople function itself
        let task = session.dataTaskWithURL(url!, completionHandler: completionHandler)
        // Actually "execute" the task. This is the line that actually makes the request that we set up above
        task.resume()
    }

    
    
}
