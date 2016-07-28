//
//  SplashViewController.swift
//  pokedex
//
//  Created by Daniel Ra on 7/15/16.
//  Copyright © 2016 Daniel Ra. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

class SplashViewController: UIViewController {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var pokedexButton: UIButton!
    var player: AVAudioPlayer?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var pokemons = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("> splashcontroller viewDidLoad")
        playSound()
        displayEffects()
        readPokemons()
        validatePokemons()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        playPikachu()
    }
    func displayEffects() {
        if (checkButton != nil) {
//            checkButton.layer.shadowColor = UIColor.blackColor().CGColor
//            checkButton.layer.shadowOpacity = 1
//            checkButton.layer.shadowOffset = CGSizeZero
//            checkButton.layer.shadowRadius = 10
            
//            pokedexButton.layer.shadowColor = UIColor.blackColor().CGColor
//            pokedexButton.layer.shadowOpacity = 1
//            pokedexButton.layer.shadowOffset = CGSizeZero
//            pokedexButton.layer.shadowRadius = 10
//            pokedexButton.alpha = 0
            
            UIView.animateWithDuration(3.3, delay: 0.6, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.pokedexButton.alpha = 1
                }, completion: nil)
        }
        
        
        
    }
    
    func playSound() {
        let url = NSBundle.mainBundle().URLForResource("testsound", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }

    func stopSound() {
        let url = NSBundle.mainBundle().URLForResource("testsound", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            guard let player = player else { return }
            player.stop()
        } catch let error as NSError {
            print(error.description)
        }
    }
    func playPikachu() {
        let url = NSBundle.mainBundle().URLForResource("pikachu", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }

    @IBAction func checkButtonPressed(sender: UIButton) {
//        playPikachu()
        let bounds = self.checkButton.bounds
        UIView.animateWithDuration(4.0, delay: 2.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .Repeat, animations: {
            self.checkButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
            self.checkButton.enabled = false
            }, completion: nil)
    }
    @IBAction func pokedexButtonPressed(sender: UIButton) {
        let bounds = self.pokedexButton.bounds
        UIView.animateWithDuration(4.0, delay: 2.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .Repeat, animations: {
            self.pokedexButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
            self.pokedexButton.enabled = false
            }, completion: nil)
    }
    
    func getPokemons() {
        print("> getPokemons()")
        Pokemon.getAllPokemons() {
            data, response, error in
            do {
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                    print("> jsonResult received")
                    if let results = jsonResult["results"] as? NSArray {
                        var i = 1
                        for index in results {
                            let pokemon = NSEntityDescription.insertNewObjectForEntityForName("Pokemon", inManagedObjectContext: managedObjectContext) as! Pokemon
                            pokemon.index = i
                            i += 1
                            pokemon.name = "\(index.valueForKey("name")!.capitalizedString)"
                            pokemon.url = "\(index.valueForKey("url")!)"
                            if managedObjectContext.hasChanges {
                                do {
                                    try managedObjectContext.save()
                                    print("Successfully added a pokemon to DB: \(pokemon.index!), \(pokemon.name!)")
                                } catch {
                                    print("\(error)")
                                }
                            } // end of 'if managedObjectContext.hasChanges'
                        } // end of 'for index in results'
                    } // end of 'if let results = jsonResult["results"] as? NSArray'
                }
                self.readPokemons()
            } catch {
                print("Something went wrong")
            }
        }
    }
    
    func readPokemons() {
        if (checkButton != nil) {
            checkButton.hidden = true
        }
        let userRequest = NSFetchRequest(entityName: "Pokemon")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            pokemons = results as! [Pokemon]
        } catch {
            print("\(error)")
        }
        print("\(pokemons.count) Pokemons exist!")
        if pokemons.count == 151 && checkButton != nil {
            dispatch_async(dispatch_get_main_queue(), {
                self.checkButton.hidden = false
            })

        }
    }
    
    func validatePokemons() {
        if (pokemons.count == 151) && ((pokemons[0].name! != "Bulbasaur")
            || (pokemons[100].name != "Electrode")
            || (pokemons[150].name != "Mew")) {
            deletePokemons()
            getPokemons()
        }
        else if (pokemons.count != 151) {
            deletePokemons()
            getPokemons()
        }
        for poke in pokemons {
            print("Pokemon name from db: \(poke.name!)")
        }

    }
    func deletePokemons() {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Pokemon")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    
}