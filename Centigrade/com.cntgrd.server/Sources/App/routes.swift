import Routing
import Vapor

import CentigradeData

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    router.get("data") { req in
        
        
        
        return "data"
    }
    
    let measurementController = MeasurementController()
    try router.register(collection: measurementController)
    
    let stationController = StationController()
    try router.register(collection: stationController)
    
//    // Example of configuring a controller
//    let todoController = TodoController()
//    router.get("todos", use: todoController.index)
//    router.post("todos", use: todoController.create)
//    router.delete("todos", Todo.parameter, use: todoController.delete)
}
