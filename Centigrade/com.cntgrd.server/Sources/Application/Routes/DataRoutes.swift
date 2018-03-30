//
//  DataRoutes.swift
//  com.cntgrd.server
//
//  Created by andy on 3/30/18.
//

import Foundation
import Kitura
import SwiftProtobuf
import CentigradeData

func initializeDataRoutes(router: Router, requestHelper: RequestHelper) {
    let tempPressureHumidityUUID = UUID().uuidString
    let atmosphereUUID = UUID().uuidString
    let stationUUID = UUID().uuidString
    
    
    router.get("/data") { request, response, next in
        let acceptHeader = requestHelper.acceptHeader(headers: request.headers)
        response.headers.append("Content-Type", value: acceptHeader.contentType)
        
        
        let temperature = Centigrade_Measurement(time: UInt64(NSDate().timeIntervalSince1970),
                                                 measurement: .temperature(Centigrade_Celsius(value: 22)),
                                                 sensor: Centigrade_Sensor(uuid: tempPressureHumidityUUID, sensorType: .temperature))
        let humidity = Centigrade_Measurement(time: UInt64(NSDate().timeIntervalSince1970),
                                              measurement: .humidity(Centigrade_Percent(value: 41)),
                                              sensor: Centigrade_Sensor(uuid: tempPressureHumidityUUID, sensorType: .humidity))
        let pressure = Centigrade_Measurement(time: UInt64(NSDate().timeIntervalSince1970),
                                              measurement: .pressure(Centigrade_Hectopascals(value: 1013)),
                                              sensor: Centigrade_Sensor(uuid: tempPressureHumidityUUID, sensorType: .pressure))
        
        let totalVOC = Centigrade_Measurement(time: UInt64(NSDate().timeIntervalSince1970),
                                              measurement: .totalVocs(Centigrade_PartsPerBillion(value: 7)),
                                              sensor: Centigrade_Sensor(uuid: atmosphereUUID, sensorType: .totalVoc))
        let equivalentC02 = Centigrade_Measurement(time: UInt64(NSDate().timeIntervalSince1970),
                                                   measurement: .equivalentCo2(Centigrade_PartsPerMillion(value: 410)),
                                                   sensor: Centigrade_Sensor(uuid: atmosphereUUID, sensorType: .equivalentCo2))
        
        let measurementList = [temperature, humidity, pressure, totalVOC, equivalentC02]
        let measurements = Centigrade_StationRecentMeasurements(uuid: stationUUID, measurements: measurementList)
        
        switch acceptHeader {
        case .json:
            let data = try measurements.jsonUTF8Data()
            response.send(data: data)
        case .protobuf:
            let data = try measurements.serializedData()
            response.send(data: data)
        }
        
        next()
    }
    
}
