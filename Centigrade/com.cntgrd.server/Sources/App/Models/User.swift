//
//  User.swift
//  Run
//
//  Created by andy on 4/3/18.
//

import Authentication
import Crypto
import FluentPostgreSQL
import Vapor

final class User: PostgreSQLModel {
    
    var id: Int?
    
    var email: String
    
    var password: String
    
    var verifiedEmail: Bool
    
    init(id: Int? = nil, email: String, password: String, verifiedEmail: Bool) {
        self.id = id
        self.email = email
        self.password = password
        self.verifiedEmail = verifiedEmail
    }
    
}

extension User: Content { }

extension User: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            try builder.addIndex(to: \.email, isUnique: true)
        }
    }
    
}

extension User: Parameter { }

extension User {
    
    var stations: Children<User,Station> {
        return children(\.userID)
    }
    
}
