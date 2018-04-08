//
//  Sensor.swift
//  Run
//
//  Created by andy on 4/3/18.
//

import Vapor
import FluentPostgreSQL

final class Sensor: PostgreSQLModel {
    
    var id: Int?
    
    var stationID: Station.ID
    
    var sensorType: [Int]
    
    var sensorID: UUID
    
    init(id: Int? = nil, stationID: Station.ID, sensorType: [Int], sensorID: UUID) {
        self.id = id
        self.stationID = stationID
        self.sensorType = sensorType
        self.sensorID = sensorID
    }
    
}

extension Sensor: Content { }

extension Sensor: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            try builder.addReference(from: \.stationID, to: \Station.id)
            try builder.addIndex(to: \.sensorID, isUnique: true)
        }
    }
    
}

extension Sensor: Parameter { }

extension Sensor {
    
    var station: Parent<Sensor,Station> {
        return parent(\.stationID)
    }
    
//    var sensorTypes: Parent<Sensor,SensorType> {
//        return parent(\.sensorType)
//    }
    
    var measurements: Children<Sensor,MeasurementModel> {
        return children(\.sensorID)
    }
    
}
