import Vapor
import VaporMongo
import FluentMongo


let drop = Droplet()
//try drop.addProvider(VaporMongo.Provider.self)

let mongo = try VaporMongo.Provider(database: "mofire-db", user: "hims", password: "test", host: "ds050539.mlab.com", port: 50539)
drop.addProvider(mongo)

let rc = RestaurantController()

drop.get("/") { request in
    return "Hello World!!"
}

drop.middleware.append(VersionMiddleware())

drop.preparations.append(Restaurant.self)

drop.run()
