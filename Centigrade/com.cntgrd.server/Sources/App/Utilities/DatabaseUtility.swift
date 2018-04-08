//
//  DatabaseUtility.swift
//  Run
//
//  Created by andy on 4/3/18.
//

import CentigradeData
import Crypto
import Fluent
import FluentPostgreSQL
import Foundation
import Vapor

enum DatabaseUtilityError: Error {
    case SensorNotFound
    case StationNotFound
    case UserNotFound
}

final class DatabaseUtility {
    
    let database: PostgreSQLDatabase
    let connection: PostgreSQLConnection
    let queue = MultiThreadedEventLoopGroup(numThreads: 5)
    
    let sensorTypes = ["ALTITUDE", "ANEMOMETER", "EQUIVALENT_CO2",
                       "HUMIDITY", "PRESSURE", "TEMPERATURE", "TOTAL_VOC"]
    
    init(database: PostgreSQLDatabase) throws {
        self.database = database
        self.connection = try database.makeConnection(on: queue).wait()
    }
    
    func addDummyData() {
        self.addUsers()
        self.addSensorTypes()
        self.addStations()
        self.addSensors()
        self.addMeasurements()
    }
    
    func addMeasurements() {

        // check that DB only contains the 5 measurements that have been added below
        let tempPressHumidMeasurements: [MeasurementModel]
        let atmosphericMeasurements: [MeasurementModel]
        do {
            tempPressHumidMeasurements = try getMeasurementsForSensor(sensorID: 1).wait()
            atmosphericMeasurements = try getMeasurementsForSensor(sensorID: 2).wait()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        if tempPressHumidMeasurements.count == 3 && atmosphericMeasurements.count == 2 { return }
        
        // get first user
        let user: User
        do {
            user = try getUser(email: "rrash@smu.edu").wait()!
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // get station(s) for user
        let station: Station
        do {
            station = try getFirstStationForUser(email: user.email).wait()!
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // get sensors for the given station
        let tempPressHumidSensor: Sensor
        do {
            tempPressHumidSensor = try getSensorForStation(with: [4,5,6], stationID: station.stationID).wait()!
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let atmosphericSensor: Sensor
        do {
            atmosphericSensor = try getSensorForStation(with: [3,7], stationID: station.stationID).wait()!
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let tempPressHumidSensorProtobuf = Centigrade_Sensor(
            uuid: tempPressHumidSensor.sensorID.uuidString,
            sensorType: [
                Centigrade_SensorType.humidity,
                Centigrade_SensorType.pressure,
                Centigrade_SensorType.temperature
            ]
        )
        
        let atmosphericSensorProtobuf = Centigrade_Sensor(
            uuid: atmosphericSensor.sensorID.uuidString,
            sensorType: [
                Centigrade_SensorType.equivalentCo2,
                Centigrade_SensorType.totalVoc
            ]
        )
        
        // use the found sensor's sensorID in creation of Centigrade_Measurement below (convert to String)
        
        // TODO: create switch statement somewhere that converts a given SensorType (type String) to a given sensorType enum value
        
        let nowEpoch = UInt64(Date().timeIntervalSince1970)
        
        let rawMeasurements: [(Centigrade_SensorType, Centigrade_Measurement.OneOf_Measurement, Centigrade_Sensor, Sensor)] = [
            (.humidity,      .humidity(Centigrade_Percent(value: 45)),               tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.pressure,      .pressure(Centigrade_Hectopascals(value: 1013)),         tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.temperature,   .temperature(Centigrade_Celsius(value: 22.0)),           tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.equivalentCo2, .equivalentCo2(Centigrade_PartsPerMillion(value: 409)),  atmosphericSensorProtobuf, atmosphericSensor),
            (.totalVoc,      .totalVocs(Centigrade_PartsPerBillion(value: 7)),        atmosphericSensorProtobuf, atmosphericSensor),
            
            (.humidity,      .humidity(Centigrade_Percent(value: 40)),               tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.pressure,      .pressure(Centigrade_Hectopascals(value: 1010)),         tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.temperature,   .temperature(Centigrade_Celsius(value: 23.0)),           tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.equivalentCo2, .equivalentCo2(Centigrade_PartsPerMillion(value: 408)),  atmosphericSensorProtobuf, atmosphericSensor),
            (.totalVoc,      .totalVocs(Centigrade_PartsPerBillion(value: 8)),        atmosphericSensorProtobuf, atmosphericSensor),
            
            (.humidity,      .humidity(Centigrade_Percent(value: 41)),               tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.pressure,      .pressure(Centigrade_Hectopascals(value: 1012)),         tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.temperature,   .temperature(Centigrade_Celsius(value: 24.0)),           tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.equivalentCo2, .equivalentCo2(Centigrade_PartsPerMillion(value: 407)),  atmosphericSensorProtobuf, atmosphericSensor),
            (.totalVoc,      .totalVocs(Centigrade_PartsPerBillion(value: 5)),        atmosphericSensorProtobuf, atmosphericSensor),
            
            (.humidity,      .humidity(Centigrade_Percent(value: 38)),               tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.pressure,      .pressure(Centigrade_Hectopascals(value: 1015)),         tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.temperature,   .temperature(Centigrade_Celsius(value: 20.0)),           tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.equivalentCo2, .equivalentCo2(Centigrade_PartsPerMillion(value: 410)),  atmosphericSensorProtobuf, atmosphericSensor),
            (.totalVoc,      .totalVocs(Centigrade_PartsPerBillion(value: 4)),        atmosphericSensorProtobuf, atmosphericSensor),
            
            (.humidity,      .humidity(Centigrade_Percent(value: 39)),               tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.pressure,      .pressure(Centigrade_Hectopascals(value: 1017)),         tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.temperature,   .temperature(Centigrade_Celsius(value: 25.0)),           tempPressHumidSensorProtobuf, tempPressHumidSensor),
            (.equivalentCo2, .equivalentCo2(Centigrade_PartsPerMillion(value: 400)),  atmosphericSensorProtobuf, atmosphericSensor),
            (.totalVoc,      .totalVocs(Centigrade_PartsPerBillion(value: 6)),        atmosphericSensorProtobuf, atmosphericSensor)
        ]
        
        let secondsPerDay: UInt32 = 60 * 24
        let measurementModels: [MeasurementModel] = rawMeasurements.map { (role, measurement, sensor, sensorModel) in
            // convert to protobuf object
            // (time is anytime in the last 24h)
            let randomTime: UInt64
            #if os(Linux)
                srandom(UInt32(time(nil)))
                randomTime = nowEpoch - UInt64(UInt32(random()) % secondsPerDay)
            #else
                randomTime = nowEpoch - UInt64(arc4random_uniform(secondsPerDay))
            #endif
            
            let pb = Centigrade_Measurement(
                time: randomTime,
                measurement: measurement,
                role: role,
                sensor: sensor
            )
            
            // convert to Fluent ORM model, which contains
            // redundant columns and serialized protobuf
            return MeasurementModel(
                measurementTime: Date(timeIntervalSince1970: TimeInterval(pb.time)),
                sensorID: sensorModel.id!,
                sensorRole: pb.sensorRole.rawValue,
                measurement: (try? pb.serializedData()) ?? Data()
            )
        }
        
        measurementModels.forEach { model in
            do {
                let _ = try addMeasurement(measurement: model).wait()
            } catch {
                print("FUCK")
            }
        }
    }
    
    func addSensors() {
        
        let tempPressHumidSensors = ["TEMPERATURE", "PRESSURE", "HUMIDITY"]
        let atmosphericSensors = ["EQUIVALENT_CO2", "TOTAL_VOC"]
        
        let tempPressHumidSensorTypeIDS: [SensorType]
        let atmosphericSensorTypeIDS: [SensorType]
        do {
            tempPressHumidSensorTypeIDS = try self.getSensorTypes(sensorTypes: tempPressHumidSensors).wait()
            atmosphericSensorTypeIDS = try self.getSensorTypes(sensorTypes: atmosphericSensors).wait()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let stations: [Station]
        do {
            stations = try getStationsForUser(email: "rrash@smu.edu").wait()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // no need to add duplicate sensors for the one station
        if stations.count == 1 {
            let sensors: [Sensor]
            do {
                sensors = try getSensorsForStation(stationID: stations[0].stationID).wait()
            } catch let error {
                print(error.localizedDescription)
                return
            }
            
            if sensors.count == 2 { return }
            
        }
        
        do {
            _ = try self.addSensor(sensor: Sensor(
                stationID: stations[0].id!,
                sensorType: tempPressHumidSensorTypeIDS.map { $0.id! },
                sensorID: UUID()
            )).wait()
            _ = try self.addSensor(sensor: Sensor(
                stationID: stations[0].id!,
                sensorType: atmosphericSensorTypeIDS.map { $0.id! },
                sensorID: UUID()
            )).wait()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
    }
    
    func addSensorTypes() {
        for newType in self.sensorTypes {
            do {
                _ = try self.addSensorType(sensorType: SensorType(sensorType: newType)).wait()
            } catch let error {
                print(error.localizedDescription)
                return
            }
            
        }
    }
    
    func addStations() {
        let stationID = UUID()
        
        let user: User
        do {
            user = try getUser(email: "rrash@smu.edu").wait()!
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let stations: [Station]
        do {
            stations = try getStationsForUser(email: user.email).wait()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // no need to add more than one station
        if stations.count == 1 { return }
        
        let newStation = Station(
            userID: user.id!,
            stationID: stationID
        )
        
        do {
            _ = try self.addStation(station: newStation).wait()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
    }
    
    func addUsers() {
        let email = "rrash@smu.edu"
        let password = "hunter2"
        
        let generatedSalt: Data
        do {
            generatedSalt = try CryptoRandom().generateData(count: 32)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let newUser = User(
            email: email,
            password: password,
            verifiedEmail: false
        )
        
        do {
            _ = try self.addUser(user: newUser).wait()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
    }
    
    func addMeasurement(measurement: MeasurementModel) -> Future<MeasurementModel> {
        return measurement.save(on: self.connection)
    }
    
    func addSensor(sensor: Sensor) -> Future<Sensor> {
        return sensor.save(on: self.connection)
    }
    
    func addSensorType(sensorType: SensorType) -> Future<SensorType> {
        return sensorType.save(on: self.connection)
    }
    
    func addStation(station: Station) -> Future<Station> {
        return station.save(on: self.connection)
    }
    
    func addUser(user: User) -> Future<User> {
        return user.save(on: self.connection)
    }
    
    func getMeasurementsForSensor(sensorID: Int) throws -> Future<[MeasurementModel]> {
        return try Sensor.query(on: self.connection).filter(\.id == sensorID).first().flatMap(to: [MeasurementModel].self) { sensor in
            guard let sensor = sensor else {
                throw DatabaseUtilityError.SensorNotFound
            }
            
            return try MeasurementModel.query(on: self.connection).filter(\.sensorID == sensor.id!).all()
        }
    }
    
    func getFirstStationForUser(email: String) throws -> Future<Station?> {
        return try User.query(on: self.connection).filter(\.email == email).all().flatMap(to: Station?.self) { users in
            try users[0].stations.query(on: self.connection).first()
        }
    }
    
    func getFirstUser() throws -> Future<User> {
        return User.query(on: self.connection).all().map(to: User.self) { users in
            return users[0]
        }
    }

    func getSensorForStation(with sensorType: [Int], stationID: UUID) throws -> Future<Sensor?> {
        return try Station.query(on: self.connection).filter(\.stationID == stationID).all().flatMap(to: Sensor?.self) { stations in
            try stations[0].sensors.query(on: self.connection).filter(\.sensorType == sensorType).first()
        }
    }
    
    func getSensorTypes(sensorTypes: [String]) throws -> Future<[SensorType]> {
        return try SensorType.query(on: self.connection).filter(\.sensorType ~~ sensorTypes).all()
    }
    
    func getSensorsForStation(stationID: UUID) throws -> Future<[Sensor]> {
        return try Station.query(on: self.connection).filter(\.stationID == stationID).first().flatMap(to: [Sensor].self) { station in
            guard let station = station else {
                throw DatabaseUtilityError.StationNotFound
            }
            
            return try Sensor.query(on: self.connection).filter(\.stationID == station.id!).all()
        }
    }
    
    func getStationsForUser(email: String) throws -> Future<[Station]> {
        return try User.query(on: self.connection).filter(\.email == email).first().flatMap(to: [Station].self) { user in
            guard let user = user else {
                throw DatabaseUtilityError.UserNotFound
            }
            
            return try Station.query(on: self.connection).filter(\.userID == user.id!).all()
        }
    }
    
    func getUser(email: String) throws -> Future<User?> {
        return try User.query(on: self.connection).filter(\.email == email).first()
    }
    
}
