import Foundation
import Kitura
import LoggerAPI
import Configuration
import KituraContracts
import Health
import SwiftProtobuf
import CentigradeData

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()

    public init() throws {
        router.get("/hello") { _, response, next in
            response.send(json: ["message": "hello world"])
            next()
        }
        
        
        let tempPressureHumidityUUID = UUID().uuidString
        let atmosphereUUID = UUID().uuidString
        let stationUUID = UUID().uuidString
        
        router.get("/data") { request, response, next in
            
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
            
            
            // let data = try measurements.jsonUTF8Data()
            let data = try measurements.serializedData()
            response.send(data: data)
            
            next()
        }
        
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }

}
