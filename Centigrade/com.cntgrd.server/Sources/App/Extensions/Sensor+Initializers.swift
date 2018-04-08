//
//  Sensor+Initializers.swift
//  com.cntgrd.server
//
//  Created by andy on 3/29/18.
//

import Foundation
import CentigradeData

public extension Centigrade_Sensor {
    
    public init(fields: [String], sensorType: [Centigrade_SensorType]) {
        self.init(uuid: fields[0], sensorType: sensorType)
    }
    
    public init(uuid: String? = nil, sensorType: [Centigrade_SensorType] = []) {
        self.init()
        
        if let v = uuid {
            self.uuid = v
        }
        
        if !sensorType.isEmpty {
            self.sensorType = sensorType
        }
        
    }
    
}
