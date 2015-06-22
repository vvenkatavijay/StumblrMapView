//
//  PinAnnotation.swift
//  StumblrMapView
//
//  Created by Venkata Vijay on 6/6/15.
//  Copyright (c) 2015 Venkata Vijay. All rights reserved.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    let title: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let firstName: String
    let lastName: String
    let profileImage = UIImage(named: "user.png")
    var interests = [String]()
    var numInterests: Int!
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, interests: [String]) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.interests = interests
        self.firstName = title
        self.lastName = title
       // self.profileImage =
        
        super.init()
    }
    
    var subtitle: String {
        return locationName
    }
    
    func getPinImageOfFriend(userInterests: [String], matchSliderValue: Float) -> UIImage {
        //println("Value from User: \(userInterests)")
        //println("Value from Friends: \(self.interests)")
        
        var numInterests = 0
        var pinColor: String
        var alphaValue: CGFloat
        
        for userInterest in userInterests {
            if contains(self.interests, userInterest) {
                numInterests++
            }
        }
        
        
        if Float(numInterests) < matchSliderValue * 4 {
            alphaValue = 0
        } else {
            alphaValue = 1
        }
        
        self.numInterests = numInterests
        
        switch numInterests {
        case 0:
            pinColor = "light.png"
            break
        case 1:
            pinColor = "pinGreen.png"
            break
        case 2:
            pinColor = "StumblrDarkBlueMapPin.png"
            break
        case 3:
            pinColor = "pinGreen.png"
            break
        default:
            pinColor = "pinGreen.png"
        }
        
        let image = UIImage(named: pinColor)?.alpha(alphaValue)
        return image!
    }
}
