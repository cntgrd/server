//
//  MeasurementModel.swift
//  Run
//
//  Created by andy on 4/3/18.
//

import Vapor
import FluentPostgreSQL

final class MeasurementModel: PostgreSQLModel {
    
    var id: Int?
    
    var measurementTime: Date
    
    var sensorID: Sensor.ID
    
    var sensorRole: SensorType.ID
    
    var measurement: Data
    
    init(id: Int? = nil, measurementTime: Date, sensorID: Sensor.ID, sensorRole: SensorType.ID, measurement: Data) {
        self.id = id
        self.measurementTime = measurementTime
        self.sensorID = sensorID
        self.sensorRole = sensorRole
        self.measurement = measurement
    }
    
}

// Allows `MeasurementModel` to be encoded to and decoded from HTTP messages.
extension MeasurementModel: Content { }

// Allows `MeasurementModel` to be used as a dynamic migration.
extension MeasurementModel: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            try builder.addReference(from: \.sensorID, to: \Sensor.id)
        }
    }
    
}

// Allows `MeasurementModel` to be used as a dynamic parameter in route definitions.
extension MeasurementModel: Parameter { }

extension MeasurementModel {
    
    var sensor: Parent<MeasurementModel,Sensor> {
        return parent(\.sensorID)
    }
    
    var role: Parent<MeasurementModel,SensorType> {
        return parent(\.sensorRole)
    }
    
}
