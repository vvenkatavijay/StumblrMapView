//
//  ViewController.swift
//  StumblrMapView
//
//  Created by Venkata Vijay on 6/4/15.
//  Copyright (c) 2015 Venkata Vijay. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var imageView:UIImage!
    
    let initialLocation = CLLocation(latitude: 37.775, longitude: -122.418)
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var locationArray = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.mapView.showsUserLocation = true
        //centerMapOnLocation(initialLocation)
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }*/
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        //println("Coordinates are \(location.coordinate.latitude) and \(location.coordinate.longitude)")
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        getLocations(center)
        addPoints()
    }
    
    func addPoints() {
        for index in 1...5 {
            
            var interests = [String]()
            interests.append("\(index)")
            
            var point = PinAnnotation(title: "Friend \(index)", locationName: "Home", discipline: "Poker", coordinate: locationArray[index-1], interests: interests)
            
            self.mapView.addAnnotation(point)
        }
    }
    
    func getLocations(center: CLLocationCoordinate2D) {
        for index in 1...5 {
            
            let delta = 0.002 * (Double(index) - 2.5)
            let randLocation = CLLocationCoordinate2D(latitude: center.latitude + delta, longitude:center.longitude + delta )
            locationArray.append(randLocation)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? PinAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
                view.image = annotation.getMatchingInterestsWithUser(["2", "3", "4"])
                
                let imageURL = NSURL(string:"http://pbs.twimg.com/profile_images/2284174872/7df3h38zabcvjylnyfe3_mini.png")
                let data = NSData(contentsOfURL: imageURL!)
                let userImage = UIImage(data: data!)
                var leftIconView = UIImageView(image: userImage)
                view.leftCalloutAccessoryView = leftIconView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let friend = view.annotation as! PinAnnotation
        performSegueWithIdentifier("profileSegue", sender: friend)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nc = segue.destinationViewController as! UINavigationController
        let vcs = nc.viewControllers
        let vc =  vcs[0] as! PersonProfileView
        let friendDetails = sender as! PinAnnotation
        println("Sent from \(friendDetails.title)")
    }
}

