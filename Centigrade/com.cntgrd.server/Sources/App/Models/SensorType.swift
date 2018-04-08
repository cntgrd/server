//
//  SensorType.swift
//  Run
//
//  Created by andy on 4/3/18.
//

import Vapor
import FluentPostgreSQL

final class SensorType: PostgreSQLModel {
    
    var id: Int?
    
    var sensorType: String
    
    init(id: Int? = nil, sensorType: String) {
        self.id = id
        self.sensorType = sensorType
    }
    
}

extension SensorType: Content { }

extension SensorType: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            try builder.addIndex(to: \.sensorType, isUnique: true)
        }
    }
    
}

extension SensorType: Parameter { }

extension SensorType {
    
    var measurement: Children<SensorType,MeasurementModel> {
        return children(\.id)
    }
    
}
