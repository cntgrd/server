//
//  Meters+Initializers.swift
//  com.cntgrd.server
//
//  Created by andy on 3/29/18.
//

import Foundation
import CentigradeData

public extension Centigrade_Meters {
    
    public init(fields: [String]) {
        self.init(value: Int32(fields[0]))
    }
    
    public init(value: Int32? = nil) {
        self.init()
        
        if let v = value {
            self.value = v
        }
        
    }
    
}
