//
//  UserController.swift
//  Run
//
//  Created by andy on 4/4/18.
//

import Fluent
import Vapor

final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let userRoutes = router.grouped("users")
        //        userRoutes.get("")
    }
    
}
