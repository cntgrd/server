import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(DateMiddleware.self) // Adds `Date` header to responses
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure PostgreSQL database
    let postgresConfig: PostgreSQLDatabaseConfig = PostgreSQLDatabaseConfig(
        hostname: "database",
        port: 5432,
        username: Environment.get("POSTGRES_USER")!,
        database: Environment.get("POSTGRES_DB")!,
        password: Environment.get("POSTGRES_PASSWORD")!
    )
    let postgres: PostgreSQLDatabase = PostgreSQLDatabase(config: postgresConfig)
    let dbUtility = try DatabaseUtility(database: postgres)
    if !env.isRelease || Environment.get("TRAVIS") != nil {
        dbUtility.addDummyData()
    } else {
        dbUtility.addSensorTypes()
    }
    
    /// Register the configured database to the database config.
    var databases = DatabaseConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: SensorType.self, database: .psql)
    migrations.add(model: Station.self, database: .psql)
    migrations.add(model: Sensor.self, database: .psql)
    migrations.add(model: MeasurementModel.self, database: .psql)
    services.register(migrations)

}
