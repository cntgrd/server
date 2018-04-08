//
//  StationController.swift
//  Run
//
//  Created by andy on 4/4/18.
//

import CentigradeData
import Fluent
import Vapor

final class StationController: RouteCollection {
    func boot(router: Router) throws {
        let stationRoutes = router.grouped("stations")
        stationRoutes.get(Station.parameter, use: getHandler)
        stationRoutes.get(Station.parameter, "sensors", use: getSensors)
        stationRoutes.get(Station.parameter, "measurements", use: getRecentMeasurements)
    }
 
    func getFirstStation(_ req: Request) throws -> Future<Response> {
        return Station.query(on: req).first().map(to: Response.self) { station in
            guard let station = station else {
                throw Abort(.notFound)
            }

            let dummyProtobuf = Centigrade_Celsius(value: 22.0)
            
            let res = req.makeResponse()
            res.http.headers = ["Content-Type": "application/json"]
            res.http.body = try HTTPBody(string: dummyProtobuf.jsonString())
            
            return res

        }
    }
    
    func getHandler(_ req: Request) throws -> Future<Station> {
        return try req.parameter(Station.self)
    }
    
    func getSensors(_ req: Request) throws -> Future<[Sensor]> {
        return try req.parameter(Station.self).flatMap(to: [Sensor].self) { station in
            return try station.sensors.query(on: req).all()
        }
    }
    
    func getRecentMeasurements(_ req: Request) throws -> Future<[[MeasurementModel]]> {
        return try req.parameter(Station.self).flatMap(to: [[MeasurementModel]].self) { station in
            return try station.sensors.query(on: req).all().flatMap(to: [[MeasurementModel]].self) { sensors in
                return try sensors.map { try $0.measurements.query(on: req).all() }.flatten(on: req)
            }
        }
    }
    
}
