//
//  NetworkErrors.swift
//  PCL_SwiftUI
//
//  Created by Deepesh on 6/13/23.
//

import Foundation

enum NetworkRequestError: Error, Codable {
    case invalidURL
    case invalidBody
    case invalidHeaders
    case invalidRequest
    case decodingError
}
