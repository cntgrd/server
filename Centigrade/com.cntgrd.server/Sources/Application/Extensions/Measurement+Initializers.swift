//
//  Measurement+Initializers.swift
//  com.cntgrd.server
//
//  Created by andy on 3/29/18.
//

import Foundation
import CentigradeData

public extension Centigrade_Measurement {
    
    public init(fields: [String], measurement: OneOf_Measurement, sensor: Centigrade_Sensor) {
        self.init(time: UInt64(fields[0]), measurement: measurement, sensor: sensor)
    }
    
    public init(time: UInt64? = nil, measurement: OneOf_Measurement? = nil, sensor: Centigrade_Sensor? = nil) {
        self.init()
        
        if let v = time {
            self.time = v
        }
        
        if let v = measurement {
            self.measurement = v
        }
        
        if let v = sensor {
            self.sensor = v
        }
        
    }
    
}
