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
        searchText = textField.text?.lowercaseString
        print(searchText!)
        let filteredArray = pokemons.filter() {
            guard let type = ($0 as Pokemon).name else {
                return false
            }
            return type.lowercaseString.rangeOfString(searchText!) != nil
        }
        for element in filteredArray {
            print("Filter Reult: \(element.valueForKey("name")!), \(element.valueForKey("index")!)")
        }
        
        if textField.text == "" {
            filteredPokemons = pokemons
            updateImage(index)
        } else {
            filteredPokemons = filteredArray
            pokemonPicker.selectRow(0, inComponent: 0, animated: true)
            updateImage(0)
        }
        pokemonPicker.delegate = self // reloads UIPickerView
    }
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var pokemonPicker: UIPickerView!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var cpSlider: UISlider!

    var index = 1
    var cp = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        print("AddViewController viewDidLoad")
        buttonEffect()
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
    func buttonEffect() {
        if (addButton != nil) {
//            addButton.layer.shadowColor = UIColor.blackColor().CGColor
//            addButton.layer.shadowOpacity = 1
//            addButton.layer.shadowOffset = CGSizeZero
//            addButton.layer.shadowRadius = 10
//            addButton.alpha = 0
            
            UIView.animateWithDuration(3.3, delay: 0.6, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.addButton.alpha = 1
                }, completion: nil)
        }
    }
    func updateImage(row: Int) {
        if filteredPokemons.count > 0 {
            pokemonImage.hidden = false
            addButton.hidden = false
            cpSlider.hidden = false
            cpLabel.text = "CP: \(Int(cpSlider.value))"
            let imageIndex = String(filteredPokemons[row].index!)
            let imageUrl = "https://pokeapi.co/media/sprites/pokemon/" + imageIndex + ".png"
            let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
            pokemonImage.image = myImage
            index = Int(imageIndex)!
        } else {
            pokemonImage.hidden = true
            addButton.hidden = true
            cpLabel.text = "No Search Result"
            cpSlider.hidden = true
            
        }
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
