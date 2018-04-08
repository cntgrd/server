//
//  PartsPerMillion+Initializers.swift
//  com.cntgrd.server
//
//  Created by andy on 3/29/18.
//

import Foundation
import CentigradeData

public extension Centigrade_PartsPerMillion {
    
    public init(fields: [String]) {
        self.init(value: UInt32(fields[0]))
    }
    
    public init(value: UInt32? = nil) {
        self.init()
        
        if let v = value {
            self.value = v
        }
        
    }
    
}
