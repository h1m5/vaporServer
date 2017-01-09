//
//  RestaurantController.swift
//  VaporServer
//
//  Created by Imhoisili Otokhagua on 04/01/2017.
//
//

import Vapor
import HTTP
import MongoKitten

final class RestaurantController{
    
    init() {
        drop.resource("api/restaurants", self)
        drop.get("api/images", String.self, handler: serveGridFS)
    }
    
    let gridFS: GridFS = {
        let server = try! MongoKitten.Server(mongo_remoteUri)
//        let server = try! MongoKitten.Server(at: mongo_localHost)
        let db = server["mofire-db"]
        let gfs = try! GridFS(in: db)
        return gfs
    }()
    
    func serveGridFS(_ req: Request, imageId: String) throws -> ResponseRepresentable {
        return try gridFS.serve(byId: ObjectId.init(imageId))
    }
    
    func getAll(_ req: Request) throws -> ResponseRepresentable {
        return try Restaurant.all().makeNode().converted(to: JSON.self)
    }
    
    func show(_ req: Request, restaurant: Restaurant) throws -> ResponseRepresentable {
        return restaurant
    }
    
    func create(_ req: Request) throws -> ResponseRepresentable {
        var restaurant = try req.postRestaurant()
        guard let imageMultipart = req.multipart?[restaurant.imageName!] else { throw Abort.badRequest }
        restaurant.imageId = try gridFS.store(file: imageMultipart.file!).hexString
        restaurant.imageUri = getUrlForImage(req: req, r: restaurant)
        try restaurant.save()
        return restaurant
    }
    
    private func getUrlForImage(req : Request, r : Restaurant) -> String {
        return  "\(req.uri.deletingLastPathComponent().description)/images/\(r.imageId!)"
    }
    
    func delete(_ req: Request, restaurant: Restaurant) throws -> ResponseRepresentable {
        try restaurant.delete()
        return JSON([:])
    }
    
    func update(_ req: Request, restaurant: Restaurant) throws -> ResponseRepresentable {
        
        guard let json = req.json else { throw Abort.badRequest }
        
        guard var new = try Restaurant.init(from: restaurant) else { throw Abort.badRequest }
        
        updateParameters(using: json, on: &new)
        
        try new.save()
        
        return new
    }
    
    private func updateParameters(using json:JSON, on new: inout Restaurant) {
        new.name = json["name"] != nil ? json["name"]?.string : new.name
        new.type = json["type"] != nil ? json["type"]?.string : new.type
        new.location = json["location"] != nil ? json["location"]?.string : new.location
        new.imageName = json["imageName"] != nil ? json["imageName"]?.string : new.imageName
        new.imageUri = json["imageUri"] != nil ? json["imageUri"]?.string : new.imageUri
        new.imageId = json["imageId"] != nil ? json["imageId"]?.string : new.imageId
        new.phone = json["phone"] != nil ? json["phone"]?.string : new.phone
        new.visited = json["visited"] != nil ? (json["visited"]?.bool)! : new.visited
        new.rating = json["rating"] != nil ? (json["rating"]?.string)! : new.rating
        new.exists = json["exists"] != nil ? (json["exists"]?.bool)! : new.exists
    }
    
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Restaurant.query().delete()
        return JSON([])
    }
    
    func replace(_ req: Request, restaurant: Restaurant) throws -> ResponseRepresentable {
        try restaurant.delete()
        return try create(req)
    }
}

extension RestaurantController: ResourceRepresentable {
    typealias Model = Restaurant
    
    func makeResource() -> Resource<Restaurant> {
        return Resource(
            index: getAll,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func postRestaurant() throws -> Restaurant {
        if let jsn = json {
            return try Restaurant(node: jsn)
        } else {
            if let multi = multipart {
                let name = multi["name"]?.string
                let type = multi["type"]?.string
                let location = multi["location"]?.string
                let imageName = multi["imageName"]?.string
                let imageUri = multi["imageUri"]?.string
                let phone = multi["phone"]?.string
                let visited = multi["visited"]?.string == "true" ? true : false
                let rating = multi["rating"]?.string
                
                return Restaurant.init(name: name, type: type, location: location, imageName: imageName, imageUri: imageUri, phone: phone, visited: visited, rating: rating)
            }
        }
        
        throw Abort.badRequest
    }
}


