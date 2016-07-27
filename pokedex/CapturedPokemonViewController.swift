//
//  CapturedPokemonViewController.swift
//  pokedex
//
//  Created by Yung Kim on 7/20/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import UIKit
import CoreData

class CapturedPokemonViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var capturedPokemons = [CapturedPokemon]()
    var previousIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.hidden = true
        readPokemons()
        view.backgroundColor = UIColor.redColor()
        print("CapturedPokemonViewController viewDidLoad")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.hidden = true
        deleteButton.hidden = true
        readPokemons()
        view.backgroundColor = UIColor.redColor()
        print("CapturedPokemonViewController viewWillAppear")
        
    }
    
    func readPokemons() {
        let userRequest = NSFetchRequest(entityName: "CapturedPokemon")
        userRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            capturedPokemons = results as! [CapturedPokemon]
        } catch {
            print("\(error)")
        }
        collectionView.reloadData()
        print("\(capturedPokemons.count) Pokemons caught!")
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalLabel.text = "Total: \(capturedPokemons.count)"
        if capturedPokemons.count == 0 {
            totalLabel.text = "You Haven't Caught Any Pokemon Yet!"
        }
        return capturedPokemons.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.cellLabel.text = capturedPokemons[indexPath.row].name
     
        
        let imageUrl = "https://pokeapi.co/media/sprites/pokemon/" + String(Int(capturedPokemons[indexPath.row].index!)) + ".png"
        let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
        
        cell.cellImage.image = myImage
       
        
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Tapped a pokemon")
        nameLabel.backgroundColor = UIColor.redColor()
        nameLabel.text = "\(indexPath.row+1) \(capturedPokemons[indexPath.row].name!) CP: \(capturedPokemons[indexPath.row].cp!) \(capturedPokemons[indexPath.row].createdAt!)"
        nameLabel.hidden = false
        deleteButton.hidden = false
        if (previousIndex != nil) {
            collectionView.cellForItemAtIndexPath(previousIndex!)?.backgroundColor = UIColor.redColor()
        }
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.redColor()
        previousIndex = indexPath

        
    }
    
    @IBAction func homeButtonPressed(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func deleteButtonPressed(sender: UIButton) {
        print(previousIndex!.row)
        let commit = capturedPokemons[previousIndex!.row]
        managedObjectContext.deleteObject(commit)
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
                readPokemons()
            } catch {
                print("\(error)")
            }
        }
        collectionView.reloadData()
    }
    
    
}
