//
//  PokedexDetailsTableViewController.swift
//  pokedex
//
//  Created by Daniel Ra on 7/26/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import Foundation
import UIKit

class PokedexDetailsTableViewController: UITableViewController {
    
    
    var PokemonNum: Int!
    
    var Pokemons = ["0"]
    
    var name: String!
    var weight: String!
    var height: String!
    var experience: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPokemons()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pokemons.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell") as! PokemonDetailViewList
        
        cell.nameLabel?.text = "Name: \(name)"
        cell.heightLabel?.text = "Height: \(height)"
        cell.weightLabel?.text = "Weight: \(weight)"
        cell.experienceLabel?.text = "Based Experience: \(experience)"
        
        let imageUrl = "https://pokeapi.co/media/sprites/pokemon/" + String(PokemonNum) + ".png"
        let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
        cell.pokemonImage.image = myImage
        return cell
    }
    
    func getPokemons() {
        let url = NSURL(string: "http://pokeapi.co/api/v2/pokemon/" + "\(self.PokemonNum)")
        // Create an NSURLSession to handle the request tasks
        let session = NSURLSession.sharedSession()
        // Create a "data task" which will request some data from a URL and then run a completion handler after it is done
        
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error in
            print(data)
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                print(jsonResult)
                
                print(jsonResult.valueForKey("weight"))
                
                self.name = String(jsonResult.valueForKey("name")!.capitalizedString)
                self.weight = String(jsonResult.valueForKey("weight")!)
                self.height = String(jsonResult.valueForKey("height")!)
                self.experience = String(jsonResult.valueForKey("base_experience")!)
                
                
                


                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            } catch {
                print("Something went wrong")
            }
        })
        task.resume()
    }
}