//
//  coordinate.swift
//  Schatzkarte
//
//  Created by Raphael Bühlmann on 12.10.15.
//  Copyright © 2015 Toni Suter. All rights reserved.
//

import Foundation

public class Coordinate: NSObject {
    public var Latitude: Double
    public var Longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.Latitude = latitude
        self.Longitude = longitude
    }
    
    init(coder aDecoder: NSCoder!) {
        self.Latitude = aDecoder.decodeObjectForKey("latitude") as! Double
        self.Longitude = aDecoder.decodeObjectForKey("longitude") as! Double
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(Latitude, forKey: "latitude")
        aCoder.encodeObject(Longitude, forKey: "longitude")
    }
}
