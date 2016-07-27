//
//  AddViewController.swift
//  pokedex
//
//  Created by Yung Kim on 7/21/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import UIKit

class AddViewController: SplashViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var searchText: String?
    var filteredPokemons = [Pokemon]()
    @IBAction func textFieldChanged(sender: UITextField) {
        searchText = textField.text
        print(searchText!)
        let filteredArray = pokemons.filter() {
            guard let type = ($0 as Pokemon).name else {
                return false
            }
            return type.rangeOfString(searchText!) != nil
        }
        for element in filteredArray {
            print("Filter Reult: \(element.valueForKey("name")!), \(element.valueForKey("index")!)")
        }
        
        if textField.text == "" {
            filteredPokemons = pokemons
        } else {
            filteredPokemons = filteredArray
            
            updateImage(0)
        }
        pokemonPicker.delegate = self // reloads UIPickerView
    }
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var pokemonPicker: UIPickerView!
    @IBOutlet weak var pokemonImage: UIImageView!

    var index = 1
    var cp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        print("AddViewController viewDidLoad")
        if textField.text == "" {
            filteredPokemons = pokemons
        }
//        index = filteredPokemons[0].index as! Int
        pokemonPicker.delegate = self
        pokemonPicker.dataSource = self
        
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = false
    }

    @IBAction func searchButtonPressed(sender: UIButton) {
    }
    func updateImage(row: Int) {
        let imageIndex = String(filteredPokemons[row].index!)
        let imageUrl = "https://pokeapi.co/media/sprites/pokemon/" + imageIndex + ".png"
        let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
        pokemonImage.image = myImage
        index = Int(imageIndex)!
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredPokemons[row].name
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredPokemons.count
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateImage(row)
        
    }

    
    @IBAction func ButtonPressed(sender: NSNull) {
        stopSound()
        performSegueWithIdentifier("toMap", sender: index)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let destination = segue.destinationViewController as! MapViewController
        print("index from prepare segue \(sender!)")
        destination.index = sender as! Int
        
        destination.cp = cp 
        //            destination.delegate = self
        
    }
    @IBAction func cpSliderSlided(sender: UISlider) {
        cp = Int(sender.value)
        cpLabel.text = "CP: \(cp)"
    }
    
}
