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
    let requestHelper = RequestHelper()

    public init() throws {
        initializeDataRoutes(router: router, requestHelper: requestHelper)
    }

    func postInit() throws {
        initializeHealthRoutes(app: self)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }

}
