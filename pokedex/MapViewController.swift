//
//  MapViewController.swift
//  pokedex
//
//  Created by Daniel Ra on 7/20/16.
//  Copyright © 2016 Yung Kim. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var locationManager: CLLocationManager!
    var currentLat = ""
    var currentLong = ""
    var url = "https://pokeapi.co/media/sprites/pokemon/" //1.png"
    var index = 0
    var cp = 0
//    var send = []
    var capturedPokemons = [CapturedPokemon]()
    var pokemons = [Pokemon]()
    var indexForPin: Int?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        readPokemons()
        fetchAllLocations()
        mapPokemons()
        displayAddOrTapView()
        
        print("Received index#: \(index)")
        print("Received CP: \(cp)")
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.myMapView.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        fetchAllLocations()
        mapPokemons()
        displayAddOrTapView()
    }
    func displayAddOrTapView() {
        if index != 0 {
            let imageUrl = "https://pokeapi.co/media/sprites/pokemon/" + String(index) + ".png"
            let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:imageUrl)!)!)
            pokemonImage.image = myImage
            
            nameLabel.text = pokemons[index-1].name
            cpLabel.text = "CP: \(String(cp))"
        } else {
            //        nameLabel.hidden = true
            nameLabel.text = "Total \(capturedPokemons.count) pokemons caught."
            pokemonImage.hidden = true
            cpLabel.hidden = true
            addButton.hidden = true
        }

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        //        print("Lat: \(location!.coordinate.latitude)")
        //        print("Long: \(location!.coordinate.longitude)")
        currentLat = String(location!.coordinate.latitude)
        currentLong = String(location!.coordinate.longitude)
        
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.myMapView.setRegion(region, animated: true)
    }
    
    func mapPokemons() {
        for i in 0..<capturedPokemons.count {
        
        let pokemonLat:CLLocationDegrees = capturedPokemons[i].lat as! Double
        let pokemonLong:CLLocationDegrees = capturedPokemons[i].long as! Double
        
        let pokemonCoordinate = CLLocationCoordinate2D(latitude: pokemonLat, longitude: pokemonLong)
        
//        let latDelta:CLLocationDegrees = 0.007
//        let longDelta:CLLocationDegrees = 0.007
//        let seoulSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
//        let seoulRegion = MKCoordinateRegion(center: seoulCoordinate, span: seoulSpan)
//        myMapView.setRegion(seoulRegion, animated: true)
        
        let pokemonAnnotation = MKPointAnnotation()
            
        if (capturedPokemons[i].name != nil) && (capturedPokemons[i].cp != nil) {
            let subtitle = "CP: \(capturedPokemons[i].cp!) \(capturedPokemons[i].createdAt!)"
            pokemonAnnotation.title = capturedPokemons[i].name!//String(capturedPokemons[i].index!)
            pokemonAnnotation.subtitle = subtitle
            pokemonAnnotation.coordinate = pokemonCoordinate
        
            
            myMapView.addAnnotation(pokemonAnnotation)
            }
            
            
            
        }
    }

    
    @IBOutlet weak var label: UILabel!
    @IBAction func addPokemonButton(sender: UIButton) {
        label.text = currentLat + ", " + currentLong
        
//        let pokemonLat:CLLocationDegrees = Double(currentLat)!
//        let pokemonLong:CLLocationDegrees = Double(currentLong)!
//        
//        let pokemonCoordinate = CLLocationCoordinate2D(latitude: pokemonLat, longitude: pokemonLong)
//        
//        let pokemonAnnotation = MKPointAnnotation()
//        pokemonAnnotation.title = String(index)
//        pokemonAnnotation.subtitle = "CP: 1000"
        //        pokemonAnnotation.
//        pokemonAnnotation.coordinate = pokemonCoordinate
        
//        myMapView.addAnnotation(pokemonAnnotation)
        
        
//        print(pokemonAnnotation)
        
        
        if (Double(currentLat) != nil) || (Double(currentLong) != nil) {
            let location = NSEntityDescription.insertNewObjectForEntityForName("CapturedPokemon", inManagedObjectContext: managedObjectContext) as! CapturedPokemon
            location.lat = Double(currentLat)!
            location.long = Double(currentLong)!
            location.cp = cp
            location.index = index
            location.name = pokemons[index-1].name
            location.createdAt = NSDate()
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                    print("Successfully saved location")
                } catch {
                    print("\(error)")
                }
            }
            fetchAllLocations()
            mapPokemons()
        } else {
            label.text = "GPS Signal Lost!"
        }
    }
    
    func fetchAllLocations() {
        let userRequest = NSFetchRequest(entityName: "CapturedPokemon")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            capturedPokemons = results as! [CapturedPokemon]
        } catch {
            print("\(error)")
        }
    }
    
    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        func mapView(mapView: MKMapView!,
//                     viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let identifier = "pokemonAnnotation"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if pinView == nil {
            //println("Pinview was nil")
            
            //Create a plain MKAnnotationView if using a custom image...
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
//            for annotation in mapView.annotations as [MKAnnotation] {
//            print(annotation)
//            }
            pinView!.canShowCallout = true
//            print(pokemons[0].valueForKey("index")!)
            for pokemon in pokemons {
//                print(pokemon.valueForKey("name")!)
//                print(pokemon.valueForKey("index")!)
//                print(self.indexForPin)
                if annotation.title!! == String(pokemon.valueForKey("name")!) {
                    self.indexForPin = pokemon.valueForKey("index")! as! Int
//                    print(self.indexForPin!)
                }
            }
//            print(self.indexForPin!)
            url = url + String(self.indexForPin!) + ".png"
//            url = url + String(index) + ".png"
            let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:url)!)!)
            
            
            pinView!.image = myImage//UIImage(named: test)
            url = "https://pokeapi.co/media/sprites/pokemon/"
//            pinView!.annotation?
//            print(pinView!.detailCalloutAccessoryView)
        }
        else {
            //Unrelated to the image problem but...
            //Update the annotation reference if re-using a view...
            pinView!.annotation = annotation
        }

        
        return pinView
        
    }
    
    func readPokemons() {
        let userRequest = NSFetchRequest(entityName: "Pokemon")
        do {
            let results = try managedObjectContext.executeFetchRequest(userRequest)
            pokemons = results as! [Pokemon]
        } catch {
            print("\(error)")
        }
        
        print("\(pokemons.count) Pokemons exist!")
    }

}

