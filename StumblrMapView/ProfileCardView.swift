//
//  ProfileCardView.swift
//  StumblrMapView
//
//  Created by Venkata Vijay on 6/17/15.
//  Copyright (c) 2015 Venkata Vijay. All rights reserved.
//

import UIKit
import CoreLocation

class ProfileCardView: UIViewController {

   
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var friendData: PinAnnotation!
    var center: CLLocationCoordinate2D!
    var userInterests = [String]()
    var friendInterests = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLabel.text = friendData.firstName
        lastNameLabel.text = friendData.lastName
        let userLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let friendLocation = CLLocation(latitude: friendData.coordinate.latitude, longitude: friendData.coordinate.longitude)
        
        let distanceInKilometers = NSString(format: "%.1f", userLocation.distanceFromLocation(friendLocation) / 1000)
        
        distanceLabel.text = "\(distanceInKilometers) km"
        
        matchesLabel.text =  "\(friendData.numInterests) matches"
        profilePictureImageView.contentMode = .ScaleAspectFit
        profilePictureImageView.image = friendData.profileImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
