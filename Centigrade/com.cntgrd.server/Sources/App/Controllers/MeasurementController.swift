//
//  MeasurementController.swift
//  Run
//
//  Created by andy on 4/3/18.
//

import Fluent
import Vapor

final class MeasurementController: RouteCollection {
    func boot(router: Router) throws {
        let measurementRoutes = router.grouped("measurements")
//        measurementRoutes.get("all", use: index)
    }
    
//    func index(_ req: Request) throws -> Future<[MeasurementModel]> {
//        return MeasurementModel.query(on: req).all()
//    }
    
}
