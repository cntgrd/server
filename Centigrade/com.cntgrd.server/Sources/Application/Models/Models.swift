import SwiftKuery
import SwiftKueryPostgreSQL

class Users: Table {
    let tableName: String = "Users"
    let id = Column("id", Int32.self, autoIncrement: true, primaryKey: true)
    let email = Column("email", Varchar.self, length: 50)
}
