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
    var interests = [String]()
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, interests: [String]) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.interests = interests
        
        super.init()
    }
    
    var subtitle: String {
        return locationName
    }
    
    func getPinImageOfFriend(userInterests: [String], matchSliderValue: Float) -> UIImage {
        println("Value from User: \(userInterests)")
        println("Value from Friends: \(self.interests)")
        
        var numInterests = 0
        var pinColor: String
        var alphaValue: CGFloat
        
        for userInterest in userInterests {
            if contains(self.interests, userInterest) {
                numInterests++
            }
        }
        
        
        if Float(numInterests) < matchSliderValue * 4 {
            alphaValue = 0.05
        } else {
            alphaValue = 1
        }
        
        
        
        switch numInterests {
        case 0:
            pinColor = "pinGray.png"
            break
        case 1:
            pinColor = "pinPurple.png"
            break
        case 2:
            pinColor = "pinOrange.png"
            break
        case 3:
            pinColor = "pinRed.png"
            break
        default:
            pinColor = "pinGreen.png"
        }
        
        let image = UIImage(named: pinColor)?.alpha(alphaValue)
        return image!
    }
}
