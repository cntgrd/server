//
//  Celsius+Initializers.swift
//  com.cntgrd.server
//
//  Created by andy on 3/29/18.
//

import Foundation
import CentigradeData

public extension Centigrade_Celsius {
    
    public init(fields: [String]) {
        self.init(value: Double(fields[0]))
    }
    
    public init(value: Double? = nil) {
        self.init()
        
        if let v = value {
            self.value = v
        }
        
    }
    
}
