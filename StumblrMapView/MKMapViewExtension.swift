//
//  MKMapViewExtension.swift
//  StumblrMapView
//
//  Created by Venkata Vijay on 6/21/15.
//  Copyright (c) 2015 Venkata Vijay. All rights reserved.
//

import Foundation

import MapKit
import Parse

typealias Edges = (ne: PFGeoPoint, sw: PFGeoPoint)

extension MKMapView {
    func edgePoints() -> Edges {
        let nePoint = CGPoint(x: self.bounds.maxX, y: self.bounds.origin.y)
        let swPoint = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        let neCoord = self.convertPoint(nePoint, toCoordinateFromView: self)
        let swCoord = self.convertPoint(swPoint, toCoordinateFromView: self)
        
        let neParse = PFGeoPoint(latitude: neCoord.latitude, longitude: neCoord.longitude)
        let swParse = PFGeoPoint(latitude: swCoord.latitude, longitude: swCoord.longitude)
        
        return (ne: neParse, sw: swParse)
    }
}