//
//  VersionMiddleware.swift
//  VaporServer
//
//  Created by Imhoisili Otokhagua on 02/01/2017.
//
//

import Vapor
import HTTP

final class VersionMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)
        
        response.headers["Version"] = "API v1.0"
        
        return response
    }
    
}
