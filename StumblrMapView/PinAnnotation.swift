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
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return locationName
    }
}
