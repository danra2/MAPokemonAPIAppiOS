//
//  PokedexListViewController.swift
//  pokedex
//
//  Created by Daniel Ra on 7/26/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PokedexListViewController: UITableViewController {
    @IBOutlet var tableview: UITableView!
    var pokemonList: [Pokemon] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("pokemonDetails", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pokemonDetails" {
            let destination = segue.destinationViewController as! PokedexDetailsTableViewController
            if let indexPath = sender as? NSIndexPath{
                destination.PokemonNum = pokemonList[indexPath.row].index as? Int
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")!
        cell.textLabel?.text = pokemonList[indexPath.row].name
        return cell
    }

    
    
    func fetchAll() {
        let request = NSFetchRequest(entityName: "Pokemon")
        do {
            let response = try managedObjectContext.executeFetchRequest(request)
            pokemonList = response as! [Pokemon]
        } catch {
            print("oops no fetch")
        }
     
    }
}



