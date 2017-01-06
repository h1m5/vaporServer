import Vapor
import VaporMongo

let drop = Droplet()

try drop.addProvider(VaporMongo.Provider.self)

let rc = RestaurantController()

drop.middleware.append(VersionMiddleware())

drop.preparations.append(Restaurant.self)

drop.run()
