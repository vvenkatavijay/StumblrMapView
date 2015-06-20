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
    @IBOutlet weak var matchSlider: UISlider!
    var imageView:UIImage!
    
    var center: CLLocationCoordinate2D!
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    var locationArray = [CLLocationCoordinate2D]()
    
    var profileController: ProfileCardView!
    var animator: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.mapView.showsUserLocation = true
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        animator = UIDynamicAnimator(referenceView: view)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation

        //println("Coordinates are \(location.coordinate.latitude) and \(location.coordinate.longitude)")
        
        self.center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: false)
        
        getLocations(center)
        addPoints()
    }
    
    func addPoints() {
        for index in 1...5 {
            
            var interests = [String]()
            interests.append("\(index)")
            interests.append("\(index+1)")
            
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
            }
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
                view.image = annotation.getPinImageOfFriend(["2", "3", "4"], matchSliderValue: self.matchSlider.value)
            
                let userImage = UIImage(named: "twitter.png")
                var leftIconView = UIImageView(image: userImage)
                view.leftCalloutAccessoryView = leftIconView
            
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let friend = view.annotation as! PinAnnotation
        showProfileCard(friend)
        //performSegueWithIdentifier("profileSegue", sender: friend)
    }


    @IBAction func onMapTap(sender: UITapGestureRecognizer) {
        println("Map Tapped")
        dismissProfileCard()
    }
    
    @IBAction func onMatchValueChanged(sender: AnyObject) {
        println("Value did change called")
        mapView.removeAnnotations(mapView.annotations)
        self.addPoints()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      /*  let nc = segue.destinationViewController as! UINavigationController
        let vcs = nc.viewControllers
        let vc =  vcs[0] as! PersonProfileView
        let friendDetails = sender as! PinAnnotation
        //println("Sent from \(friendDetails.title)") */
    }
    
    func createProfileCard(friend: PinAnnotation) {
        // Here the detailsController and it's view are created and initiated
        let profileWidth: CGFloat = view.bounds.width - 20
        let profileHeight: CGFloat = 2*view.bounds.height/3
        let profileViewFrame: CGRect = CGRectMake(0, view.bounds.height, profileWidth, profileHeight)
        
        profileController = storyboard?.instantiateViewControllerWithIdentifier("profileCard") as! ProfileCardView
        profileController.friendData = friend
        profileController.center = self.center
        
        self.addChildViewController(profileController)
        profileController.view.frame = profileViewFrame
        view.addSubview(profileController.view)
        profileController.didMoveToParentViewController(self)
        
        println("Done creating")
    }
    
    func showProfileCard(friend: PinAnnotation) {
        // Create the details if they are not already there
        if (profileController == nil) {
            createProfileCard(friend)
            
            animator.removeAllBehaviors()
            
            // Animate the details view using UIKit Dynamics
            var snapBehaviour: UISnapBehavior = UISnapBehavior(item: profileController.view, snapToPoint: CGPoint(x: view.bounds.width/2, y: view.bounds.height-profileController.view.bounds.height/2))
            
            
            /*var pushBehavior: UIPushBehavior = UIPushBehavior(items: [profileController], mode: .Continuous)
            pushBehavior.setAngle(CGFloat(M_PI_2) , magnitude: 0.3) */
            
            animator.addBehavior(snapBehaviour)
        }
    }
    
    func dismissProfileCard() {
        if (profileController != nil) {
            animator.removeAllBehaviors()
            
            // Again use UIKit Dynamics to animate the details out of the visible area
            var gravityBehaviour: UIGravityBehavior = UIGravityBehavior(items: [profileController.view])
            gravityBehaviour.gravityDirection = CGVectorMake(0.0, 10.0)
            animator.addBehavior(gravityBehaviour)
            
            var itemBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [profileController.view])
            itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), forItem: profileController.view)
            animator.addBehavior(itemBehaviour)
            
            // I waint 400ms until the view is animated out of the visible area and then completely kill/remove controller and the view
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(0.4 * Double(NSEC_PER_SEC))
                ),
                
                dispatch_get_main_queue(), {    
                    self.profileController.removeFromParentViewController()
                    self.profileController = nil
            })
        }
    }


}

