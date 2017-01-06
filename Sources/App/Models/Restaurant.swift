//
//  Restaurant.swift
//  VaporServer
//
//  Created by Imhoisili Otokhagua on 04/01/2017.
//
//

import Vapor
import Fluent
import Foundation

final class Restaurant: Model {

    var id: Node?
    var name: String?
    var type: String?
    var location: String?
    var imageName: String?
    var imageUri: String?
    var imageId: String?
    var phone: String?
    var visited: Bool?
    var rating: String?
    
    var exists: Bool
    
    init(name:String?, type:String?, location:String?, imageName:String?, imageUri:String?="", imageId: String?="", phone:String?, visited:Bool?=false, rating:String?) {
        self.name = name
        self.type = type
        self.location = location
        self.imageName = imageName
        self.imageUri = imageUri
        self.imageId = imageId
        self.phone = phone
        self.visited = visited
        self.rating = rating
        self.exists = true
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        type = try node.extract("type")
        location = try node.extract("location")
        imageName = try node.extract("imageName")
        imageUri = try node.extract("imageUri")
        imageId = try node.extract("imageId")
        phone = try node.extract("phone")
        visited = try node.extract("visited")
        rating = try node.extract("rating")
        exists = try node.extract("exists")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id" : id,
            "name" : name,
            "type" : type,
            "location" : location,
            "imageName" : imageName,
            "imageUri" : imageUri,
            "imageId" : imageId,
            "phone" : phone,
            "visited" : visited,
            "rating" : rating,
            "exists" : exists
            ])
    }
    
}

extension Restaurant {
    public convenience init?(from restaurant: Restaurant) throws {
        self.init(name: restaurant.name,
                  type: restaurant.type,
                  location: restaurant.location,
                  imageName: restaurant.imageName,
                  imageUri: restaurant.imageUri,
                  imageId: restaurant.imageId,
                  phone: restaurant.phone,
                  visited: restaurant.visited,
                  rating: restaurant.rating)
        self.id = restaurant.id
    }
}

extension Restaurant: Preparation {
    static func prepare(_ database: Database) throws {

    }
    
    static func revert(_ database: Database) throws {

    }
}
