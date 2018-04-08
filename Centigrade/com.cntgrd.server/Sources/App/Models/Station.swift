//
//  Station.swift
//  Run
//
//  Created by andy on 4/3/18.
//

import Vapor
import FluentPostgreSQL

enum StationError: Error {
    case invalidUUID
}

final class Station: PostgreSQLModel {
    
    var id: Int?
    
    var userID: User.ID
    
    var stationID: UUID
    
    init(id: Int? = nil, userID: User.ID, stationID: UUID) {
        self.id = id
        self.userID = userID
        self.stationID = stationID
    }
    
    init(stationID: String) throws {
        self.userID = User.ID()
        guard let uuid = UUID(stationID) else {
            throw StationError.invalidUUID
        }
        self.stationID = uuid
    }
    
}

extension Station: Content { }

extension Station: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            try builder.addReference(from: \.userID, to: \User.id)
            try builder.addIndex(to: \.stationID, isUnique: true)
        }
    }
    
}

extension Station: Parameter { }

extension Station {
    
    var sensors: Children<Station,Sensor> {
        return children(\.stationID)
    }
    
    var user: Parent<Station,User> {
        return parent(\.userID)
    }
    
}
