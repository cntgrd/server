//
//  Sensor+Initializers.swift
//  com.cntgrd.server
//
//  Created by andy on 3/29/18.
//

import Foundation
import CentigradeData

public extension Centigrade_Sensor {
    
    public init(fields: [String], sensorType: SensorType) {
        self.init(uuid: fields[0], sensorType: sensorType)
    }
    
    public init(uuid: String? = nil, sensorType: Centigrade_Sensor.SensorType? = nil) {
        self.init()
        
        if let v = uuid {
            self.uuid = v
        }
        
        if let v = sensorType {
            self.sensorType = v
        }
        
    }
    
}
