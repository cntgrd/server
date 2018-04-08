//
//  StationRecentMeasurements+Initializers.swift
//  com.cntgrd.server
//
//  Created by andy on 3/29/18.
//

import Foundation
import CentigradeData

public extension Centigrade_StationRecentMeasurements {
    
    public init(fields: [String], measurements: [Centigrade_Measurement]) {
        self.init(uuid: fields[0], measurements: measurements)
    }
    
    public init(uuid: String? = nil, measurements: [Centigrade_Measurement] = []) {
        self.init()
        
        if let v = uuid {
            self.uuid = v
        }
        
        if !measurements.isEmpty {
            self.measurements = measurements
        }
        
    }
    
}
