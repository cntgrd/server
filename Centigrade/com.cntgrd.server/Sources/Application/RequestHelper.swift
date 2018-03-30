//
//  RequestHelper.swift
//  com.cntgrd.server
//
//  Takes inspiration from Swift+Kitura+Protobuf example here:
//  https://github.com/codete/protobuf-samples
//
//  Created by andy on 3/29/18.
//

import Foundation
import Kitura

enum AcceptHeader {
    case json
    case protobuf
    
    var contentType: String {
        switch self {
        case .json:
            return "application/json"
        case .protobuf:
            return "application/octet-stream"
        }
    }
    
}

class RequestHelper {
    
    final func acceptHeader(headers: Headers) -> AcceptHeader {
        let accept = headers["Accept"] ?? "application/json"
        switch accept {
        case "application/json":
            return .json
        case "application/octet-stream", "application/x-protobuf", "application/x-google-protobuf":
            return .protobuf
        default:
            return .json
        }
    }
    
}
