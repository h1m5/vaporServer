//
//  Helpers.swift
//  VaporServer
//
//  Created by Imhoisili Otokhagua on 05/01/2017.
//
//

import Vapor
import HTTP
import MongoKitten

let mongo_localHost = "127.0.0.1"
let mongo_remoteHost = "mongodb://hims:test@ds050539.mlab.com:50539/mofire-db"

extension GridFS {
    public func serve(byId id: ObjectId) throws -> Response {
        guard let file = try self.findOne(byID: id) else {
            return Response(status: .notFound)
        }
        
        
        return Response(chunked: { stream in
            for chunk in try file.chunked() {
                try stream.send(chunk.data)
            }
            try stream.close()
        })
    }
    
    public func serve(byName name: String) throws -> Response {
        guard let file = try self.findOne(byName: name) else {
            return Response(status: .notFound)
        }
        
        return Response(chunked: { (stream) in
            for chunk in try file.chunked() {
                try stream.send(chunk.data)
            }
            try stream.close()
        })
    }
    
    public func store(file: Multipart.File) throws -> ObjectId {
        return try self.store(data: file.data, named: file.name, withType: file.type)
    }
}
