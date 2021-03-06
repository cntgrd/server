import Foundation
import Kitura
import LoggerAPI
import Configuration
import KituraContracts
import Health

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()

    public init() throws {
        router.get("/hello") { _, response, next in
            response.send(json: ["message": "hello world"])
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
